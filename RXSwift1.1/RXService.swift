//
//  RXService.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 15/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//



import UIKit
import RxSwift
import Foundation

struct ServiceError: Codable, Error {
    
    // MARK: - Properties
    var statusMessage: String?
    var statusCode: Int?
    
    // MARK: CodingKeys
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

struct ServiceResponse {
    
    // MARK: - Properties
    var data: Data?
    var rawResponse: String?
    var response: HTTPURLResponse?
    var request: URLRequest?
    var serviceError: ServiceError?
    
}

class RxService {
    
    // MARK: - Properties
    static let shared = RxService()
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    var defaultHeaders: [String: String] = [
        "content-type": "application/json"
    ]
    
    // MARK: - Misc
    func request(httpMethod: HTTPMethod, url: URL, payload: [String: Any]? = nil,
                 headers: [String:String]? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = defaultHeaders
        
        if let dict = payload {
            do {
            let dictFromJson = try JSONSerialization.data(withJSONObject: dict, options: [])
                request.httpBody = dictFromJson
            }catch {
                
            }
        }
        
        guard let headers = headers else {
            return request
        }
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}

// MARK: - URLRequestExtension
// handle HTTPURLResponse and dispatch the request
extension URLRequest {
    
    private func setUnknowErrorFor(serviceResponse: inout ServiceResponse) {
        serviceResponse.serviceError = ServiceError(statusMessage: "An unexpected error has occured. Check your internet connection and try again.", statusCode: -999)
    }
    
    private func mapErrors(statusCode: Int, error: Error?, serviceResponse: inout ServiceResponse) {
        
        guard error == nil else {
            setUnknowErrorFor(serviceResponse: &serviceResponse)
            return
        }
        
        guard 400...499 ~= statusCode, let data = serviceResponse.data, let jsonString = String(data: data, encoding: .utf8),
            let serializedValue = try? JSONDecoder().decode(ServiceError.self, from: data) else {
                setUnknowErrorFor(serviceResponse: &serviceResponse)
                return
        }
        
        serviceResponse.rawResponse = jsonString
        
        if serializedValue.statusMessage == nil {
            setUnknowErrorFor(serviceResponse: &serviceResponse)
        } else {
            serviceResponse.serviceError = serializedValue
        }
    }
    
    // Dispatch URLRequest instance
    private func dispatch(onCompleted completion: @escaping (ServiceResponse) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: self) { data, res, error in
            
            var serviceResponse = ServiceResponse()
            
            serviceResponse.response = res as? HTTPURLResponse
            serviceResponse.request = self
            serviceResponse.data = data
            
            if let data = data {
                serviceResponse.rawResponse = String(data: data, encoding: .utf8)
            }
            
            guard let statusCode = serviceResponse.response?.statusCode else {
                self.setUnknowErrorFor(serviceResponse: &serviceResponse)
                completion(serviceResponse)
                return
            }
            
            if !(200...299 ~= statusCode) {
                self.mapErrors(statusCode: statusCode, error: error, serviceResponse: &serviceResponse)
            }
            completion(serviceResponse)
        }
        task.resume()
        return task
    }
    
    /// Use this method when there is no need to serialize service payload
    func response() -> Observable<ServiceResponse> {
        
        return Observable.create { observer in
            
            let task = self.dispatch { (serviceResponse) in
                
                if let serviceError = serviceResponse.serviceError {
                    observer.onError(serviceError)
                } else {
                    observer.onNext(serviceResponse)
                }
                
                observer.onCompleted()
                
            }
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
    /// Use this method to serialize object payload
    func response<SuccessObjectType: Codable>() -> Observable<SuccessObjectType?> {
        
        return Observable.create { observer in
            
            let task = self.dispatch { (serviceResponse) in
                
                if let serviceError = serviceResponse.serviceError {
                    observer.onError(serviceError)
                } else {
                    if let data = serviceResponse.data {
                        do {
                            let serializedObject = try JSONDecoder().decode(SuccessObjectType.self, from: data)
                            observer.onNext(serializedObject)
                        } catch let serializationError {
                            debugPrint("*** serializationError ***")
                            debugPrint(serializationError)
                            observer.onError(serializationError)
                        }
                    } else {
                        observer.onNext(nil)
                    }
                }
                
                observer.onCompleted()
                
            }
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
    
    
    
    /// Use this method to serialize array payload
    func response<SuccessObjectType: Codable>() -> Observable<[SuccessObjectType]?> {
        
        return Observable.create { observer in
            
            let task = self.dispatch { (serviceResponse) in
                
                if let serviceError = serviceResponse.serviceError {
                    observer.onError(serviceError)
                } else {
                    if let data = serviceResponse.data {
                        do {
                            let serializedObject = try JSONDecoder().decode([SuccessObjectType].self, from: data)
                            observer.onNext(serializedObject)
                        } catch let serializationError {
                            debugPrint("*** serializationError ***")
                            debugPrint(serializationError)
                            observer.onError(serializationError)
                        }
                    } else {
                        observer.onNext(nil)
                    }
                }
                
                observer.onCompleted()
                
            }
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
}

