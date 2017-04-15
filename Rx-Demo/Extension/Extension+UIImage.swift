//
//  Extension+UIImage.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/28/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func forceLazyImageDecompression() -> UIImage {
        #if os(iOS)
            UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
            self.draw(at: CGPoint.zero)
            UIGraphicsEndImageContext()
        #endif
        return self
    }
}
