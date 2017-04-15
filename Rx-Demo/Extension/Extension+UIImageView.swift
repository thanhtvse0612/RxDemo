//
//  Extension+UIImageView.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/28/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import UIKit

extension Reactive where Base: UIImageView {
    
    var downloadableImage: UIBindingObserver<Base, DownloadableImage>{
        return downloadableImageAnimated(nil)
    }
    
    func downloadableImageAnimated(_ transitionType:String?) -> UIBindingObserver<Base, DownloadableImage> {
        return UIBindingObserver(UIElement: base) { imageView, image in
            for subview in imageView.subviews {
                subview.removeFromSuperview()
            }
            switch image {
            case .content(let image):
                (imageView as UIImageView).rx.image.on(.next(image))
            case .offlinePlaceholder:
                let label = UILabel(frame: imageView.bounds)
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 35)
                label.text = "⚠️"
                imageView.addSubview(label)
            }
        }
    }
}
