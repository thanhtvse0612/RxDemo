//
//  ImageService.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 3/28/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

protocol ImageService {
    func imageFromURL(_ url: URL, reachabilityService: ReachabilityService) -> Observable<DownloadableImage>
}

class DefaultImageService: ImageService {
    let MB = 1024 * 1024
    
    static let sharedImageService = DefaultImageService() // Singleton
    
    let backgroundWorkScheduler: ImmediateSchedulerType
    let URLSession = Foundation.URLSession.shared
    
    // 1st level cache
    private let _imageCache = NSCache<AnyObject, AnyObject>()
    
    // 2nd level cache
    private let _imageDataCache = NSCache<AnyObject, AnyObject>()
    
    let loadingImage = ActivityIndicator()
    
    private init() {
        // cost is approx memory usage
        _imageDataCache.totalCostLimit = 10 * MB
        _imageCache.countLimit = 20
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
    }
    
    private func decodeImage(_ imageData: Data) -> Observable<UIImage> {
        return Observable.just(imageData)
            .observeOn(backgroundWorkScheduler)
            .map { data in
                guard let image = UIImage(data: data) else {
                    // some error
                    throw apiError("Decoding image error")
                }
                return image.forceLazyImageDecompression()
        }
    }
    
    private func _imageFromURL(_ url: URL) -> Observable<UIImage> {
        return Observable.deferred {
            let maybeImage = self._imageCache.object(forKey: url as AnyObject) as? UIImage
            
            let decodedImage: Observable<UIImage>
            
            // best case scenario, it's already decoded an in memory
            if let image = maybeImage {
                decodedImage = Observable.just(image)
            }
            else {
                let cachedData = self._imageDataCache.object(forKey: url as AnyObject) as? Data
                
                // does image data cache contain anything
                if let cachedData = cachedData {
                    decodedImage = self.decodeImage(cachedData)
                }
                else {
                    // fetch from network
                    decodedImage = Foundation.URLSession.shared.rx.data(request: URLRequest(url: url))
                        .do(onNext: { data in
                            self._imageDataCache.setObject(data as AnyObject, forKey: url as AnyObject)
                        })
                        .flatMap(self.decodeImage)
                        .trackActivity(self.loadingImage)
                }
            }
            
            return decodedImage.do(onNext: { image in
                self._imageCache.setObject(image, forKey: url as AnyObject)
            })
        }
    }
    
    /**
     Service that tries to download image from URL.
     
     In case there were some problems with network connectivity and image wasn't downloaded, automatic retry will be fired when networks becomes
     available.
     
     After image is sucessfully downloaded, sequence is completed.
     */
    func imageFromURL(_ url: URL, reachabilityService: ReachabilityService) -> Observable<DownloadableImage> {
        return _imageFromURL(url)
            .map { DownloadableImage.content(image: $0) }
            .retryOnBecomesReachable(DownloadableImage.offlinePlaceholder, reachabilityService: reachabilityService)
            .startWith(.content(image: UIImage()))
    }
}
