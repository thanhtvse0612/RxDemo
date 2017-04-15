//
//  Enum.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import UIKit

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

enum DownloadableImage {
    case content(image:UIImage)
    case offlinePlaceholder
}

enum HTTPError : Error {
    case RequestError(statusCode: Int)
    case ResponseUndefined
}

enum HTTPMethod {
    case GET
    case POST
}
