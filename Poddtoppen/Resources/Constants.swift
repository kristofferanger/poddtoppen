//
//  Constants.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-04.
//

import Foundation

struct Constants {
    
    enum API {
        case production, test, mock
    }
    
    static let api: API = .production
}
