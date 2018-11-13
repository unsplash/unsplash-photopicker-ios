//
//  NSError+Extensions.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-11-12.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import Foundation

extension NSError {
    func isNoInternetConnectionError() -> Bool {
        let noInternetConnectionErrors = [
            NSURLErrorNetworkConnectionLost,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorInternationalRoamingOff,
            NSURLErrorCallIsActive,
            NSURLErrorDataNotAllowed
        ]

        if domain == NSURLErrorDomain && noInternetConnectionErrors.contains(code) {
            return true
        }

        return false
    }
}
