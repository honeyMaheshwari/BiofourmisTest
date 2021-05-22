//
//  APIManager.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

protocol APIManager: NetworkHttpClient {
    func performGetOperation<T: Decodable>(endPoint: APIEndPoints, parameters: [String: Any], headers: [String: String], resultType: T.Type, completionHandler: @escaping (APIResponse<T>) -> Void)
    func performPostOperation<T: Decodable>(endPoint: APIEndPoints, parameters: [String: Any], headers: [String: String], resultType: T.Type, completionHandler: @escaping (APIResponse<T>) -> Void)
}

extension APIManager {
    
    func performGetOperation<T: Decodable>(endPoint: APIEndPoints, parameters: [String: Any] = [:], headers: [String: String] = [:], resultType: T.Type, completionHandler: @escaping (APIResponse<T>) -> Void) {
        if !NetworkReachabilityManager.shared.isRechable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        
        guard let url = URL(string: endPoint.path) else {
            completionHandler(.failure(APIError(type: .invalidURL)))
            return
        }
        
        callAPIWith(url, httpMethod: .get, parameters: parameters, headers: headers) { (response) in
            parseResponse(response, resultType: resultType, completionHandler: completionHandler)
        }
    }
    
    func performPostOperation<T: Decodable>(endPoint: APIEndPoints, parameters: [String: Any] = [:], headers: [String: String] = [:], resultType: T.Type, completionHandler: @escaping (APIResponse<T>) -> Void) {
        if !NetworkReachabilityManager.shared.isRechable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        
        guard let url = URL(string: endPoint.path) else {
            completionHandler(.failure(APIError(type: .invalidURL)))
            return
        }
        
        callAPIWith(url, httpMethod: .post, parameters: parameters, headers: headers) { (response) in
            parseResponse(response, resultType: resultType, completionHandler: completionHandler)
        }
    }
    
    // MARK: - Parsing
    
    func parseResponse<T: Decodable>(_ response: HttpClientResponse, resultType: T.Type, completionHandler: @escaping (APIResponse<T>) -> Void) {
        if let data = response.data, data.count > 0 {
            if 200...299 ~= response.statusCode {
                do {
                    let successResponse = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(successResponse, true))
                } catch let error {
                    let apiError = APIError(with: error, statusCode: response.statusCode, info: nil)
                    completionHandler(.failure(apiError))
                }
            } else {
                completionHandler(.failure(APIError(type: .invalidJSON)))
            }
        } else if let error = response.error {
            var apiError = APIError(with: error, statusCode: response.statusCode)
            let nsError = error as NSError
            if nsError.code == NSURLErrorCancelled {
                apiError.message = ""
            }
            completionHandler(.failure(apiError))
        } else if response.data == nil {
            completionHandler(.failure(APIError(type: .noData)))
        } else if let data = response.data, let stringData = String(data: data, encoding: .utf8), stringData.count > 0 {
            let apiError = APIError(message: stringData, type: APIErrorType.customAPIError, statusCode: response.statusCode)
            completionHandler(.failure(apiError))
        } else {
            completionHandler(.failure(APIError(type: .invalidResponse)))
        }
    }
}
