//
//  BaseClient.swift
//  BitEclipse
//
//  Created by Nhuom Tang on 24/4/19.
//  Copyright © 2019 Nhuom Tang. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PromiseKit

class BaseClient {
    
    var keyApi = ""
    
    static let shared = BaseClient.init(baseURLString: "")

    fileprivate (set) var baseURLString: String
    
    var accessToken: String?
    
    var defaultHeaders: Dictionary<String, String> {
        return [:]
    }
    
    var authenticator: (( _ header: inout HTTPHeaders, _ parameters: inout Parameters) -> Void)?
    
    lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        var headers = SessionManager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders = headers
        return SessionManager(configuration: configuration)
    }()
    
    init(baseURLString: String) {
        self.baseURLString = baseURLString
    }
    
    // MARK: -- Private Methods
    
    fileprivate func resolvePath(_ path: String) -> String {
        return baseURLString + path;
    }
    
    func request(
        _ method: HTTPMethod,
        _ path: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        let requestURL = URL(string: resolvePath(path))
        var requestHeaders = HTTPHeaders()
        var requestParams = Parameters()
        
        for (key, value) in defaultHeaders {
            requestHeaders[key] = value
        }
        
        if let parameters = parameters {
            for (key, value) in parameters {
                requestParams[key] = value
            }
        }
        
        if let headers = headers {
            for (key, value) in headers {
                requestHeaders[key] = value
            }
        }
        
        if let authenticator = authenticator {
            authenticator(&requestHeaders, &requestParams)
        }
                
        let request = sessionManager.request(requestURL!, method: method, parameters: requestParams, encoding: encoding, headers: requestHeaders)
        
        #if DEBUG
        request.responseString {(response: DataResponse<String>) in
            switch response.result {
            case .success(let value):
                if let data = value.data(using: .utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [JSONSerialization.WritingOptions.prettyPrinted])
                        let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                        debugPrint("Response:\n===============\n\(jsonString)\n===============")
                    } catch {
                        debugPrint("Response:\n===============\n\(value)\n===============")
                    }
                } else {
                    debugPrint("Response:\n===============\n\(value)\n===============")
                }
            case .failure(let error):
                debugPrint("Response:\n===============\n\(error)\n===============")
            }
        }
        #endif
        return request.validate(statusCode: 0..<1000)
    }
    
    /**
     This is depend on json response.
     All response must contains "data" key.
     */
    static func processResponse(request:URLRequest?,
                                response: HTTPURLResponse?,
                                data: Data?,
                                error: Error?) -> AppResult<Any> {
        guard error == nil else {
            if let error = error as? AFError{
                if error._code == NSURLErrorTimedOut {
                    return .failure(ServiceError.timeout)
                }
            }
            return .failure(error!)
        }
        
        guard let _ = data else {//Empty data response
            if let error = error as? AFError{
                if error._code == NSURLErrorTimedOut {
                    return .failure(ServiceError.timeout)
                }
            }
            return .failure(ServiceError.emptyResponse)
        }
        
        let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
        
        if result.isFailure {
            if let error = error as? AFError{
                if error._code == NSURLErrorTimedOut {
                    return .failure(ServiceError.timeout)
                }
            }
            return .failure(ServiceError.invalidDataFormat)
        }
        
        if let json = result.value as? [String: Any] {
            return .success(json)
        }
        if let json = result.value as? [[String: Any]] {
            return .success(json)
        }
        return .failure(ServiceError.undefined)
    }
    
    static func responseObjectSerializer<T: BaseMappable>(subKey: String? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer(serializeResponse: { (request, response, data, error) -> AppResult<T> in
            let result = processResponse(request: request, response: response, data: data, error: error)
            switch result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    if let aSubKey = subKey {
                        if let newValue = json[aSubKey] as? [String: Any] {
                            return .success(Mapper<T>().map(JSONObject: newValue)!)
                        }
                    } else {
                        return .success(Mapper<T>().map(JSONObject: json)!)
                    }
                }
                
                return .failure(ServiceError.undefined)
            case .failure(let error):
                return .failure(error)
            }
        })
    }
    
    static func responseArraySerializer<T: BaseMappable>(arraySubKey: String? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer(serializeResponse: { (request, response, data, error) -> AppResult<[T]> in
            let result = processResponse(request: request, response: response, data: data, error: error)
            switch result {
            case .success(let data):
                if let subKey = arraySubKey, let data = data as? [String: Any] {
                    let array = data[subKey]
                    if let array = array as? [[String: Any]] {
                        return .success(Mapper<T>().mapArray(JSONArray: array))
                    }
                } else if let data = data as? [[String: Any]] {
                    return .success(Mapper<T>().mapArray(JSONArray: data))
                }
                
                return .failure(ServiceError.undefined)
            case .failure(let error):
                return .failure(error)
            }
        })
    }
}

extension DataRequest {
    @discardableResult
    public func responseTask<T: BaseMappable>(subKey: String? = nil, queue: DispatchQueue? = nil) -> Promise<T> {
        return Promise { seal in
            let _ = response(queue: queue, responseSerializer: BaseClient.responseObjectSerializer(subKey: subKey), completionHandler: {(response: DataResponse<T>) in
                switch response.result {
                case .success(let value):
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
    
    @discardableResult
    func responseArrayTask<T: Mappable>(arraySubKey: String? = nil, queue: DispatchQueue? = nil) -> Promise<[T]> {
        return Promise { seal in
            let _ = response(queue: queue, responseSerializer: BaseClient.responseArraySerializer(arraySubKey: arraySubKey), completionHandler: {(response: DataResponse<[T]>) in
                switch response.result {
                case .success(let value):
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
    
    @discardableResult
    func responseStatus(queue: DispatchQueue? = nil) -> Promise<Bool> {
        return Promise { seal in
            let _ = responseJSON(queue: queue, options: .allowFragments) { (response) in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    if response.result.isFailure {
                        seal.reject(ServiceError.invalidDataFormat)
                    }
        
                    if let json = response.result.value as? [String: Any] {
                        let result = json["result"]
                        if let result = result as? String,
                            result.uppercased() == "success".uppercased() {
                            seal.fulfill(true)
                        } else if let errorCode = json["msgCode"] as? Int, let message = json["msgType"] as? String {
                            seal.reject(ServiceError(code: errorCode, reason: message))
                        } else {
                            seal.reject(ServiceError.undefined)
                        }
                    }
                }
            }
        }
    }
}


