//
//  API.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Defines
enum APIError: Error {
    case error(String)
    case errorURL
    case errorData
    case errorNetwork
    case emptyData
    case invalidURL
    case cancelRequest

    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        case .errorData:
            return "Data is not format."
        case .emptyData:
            return "Server returns no data."
        case .invalidURL:
            return "Cannot detect URL."
        case .errorNetwork:
            return "The internet connection appears to be offline."
        case .cancelRequest:
            return "Server returns no information and closes the connection."
        }
    }
}

typealias APICompletion<T> = (Result<T, APIError>) -> Void

enum APIResult {
    case success(Data?)
    case failure(APIError)
}

// MARK: - API
struct API {
    // singleton
    private static var shareAPI: API = {
        let shareAPI = API()
        return shareAPI
    }()

    static func shared() -> API {
        return shareAPI
    }

    // init
    private init() { }
}
