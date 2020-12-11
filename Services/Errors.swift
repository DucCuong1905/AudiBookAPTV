//
//  Errors.swift
//  BitEclipse
//
//  Created by Nhuom Tang on 24/4/19.
//  Copyright © 2019 Nhuom Tang. All rights reserved.
//

import UIKit

class ServiceError: LocalizedError {
    
    public enum ServiceErrorCode: Int {
        case undefined, timeout,invalidDataFormat,emptyResponse
    }

    static let undefined = ServiceError(code: .undefined, reason: "")
    static let invalidDataFormat = ServiceError(code: .invalidDataFormat, reason: "")
    static let timeout = ServiceError(code: .timeout, reason: "")
    static let emptyResponse = ServiceError(code: .emptyResponse, reason: "")

    fileprivate (set) var code: Int
    fileprivate (set) var reason: String
    fileprivate (set) var data: [String : Any]?
        
    init(code: Int, reason: String, data: [String : Any]?) {
        self.code = code
        self.reason = reason
        self.data = data
    }
    
    init(code: ServiceErrorCode, reason: String) {
        self.code = code.rawValue
        self.reason = reason
        self.data = nil
    }
    
    init(code: Int, reason: String) {
        self.code = code
        self.reason = reason
        self.data = nil
    }
    
    public var errorDescription: String? {
        get {
            return self.reason
        }
    }

}
