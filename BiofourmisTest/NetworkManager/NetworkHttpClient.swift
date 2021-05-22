//
//  NetworkHttpClient.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import Foundation

typealias HttpClientResponseBlock = (HttpClientResponse) -> Void

// MARK: - HttpMethod

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - HttpClientResponse

struct HttpClientResponse {
    var data: Data?
    var headers: [String: Any]
    var error: Error?
    var statusCode: Int
    var url: URL?
}

// MARK: - NetworkHttpClient Protocol

protocol NetworkHttpClient {
    func callAPIWith(_ url: URL, httpMethod: HttpMethod, parameters: [String: Any], headers: [String: String], completionHandler: @escaping HttpClientResponseBlock)
    func cancelTaskWithUrl(_ url: URL)
    func cancelAllAPICalls()
    func getAllRunningTasks(completionHandler: @escaping ([URLSessionTask]) -> Void)
}

extension NetworkHttpClient {
    
    func callAPIWith(_ url: URL, httpMethod: HttpMethod, parameters: [String: Any] = [:], headers: [String: String] = [:], completionHandler: @escaping HttpClientResponseBlock) {
        let request = enqueueRequestWith(url, httpMethod: httpMethod, parameters: parameters, headers: headers)
        enqueueDataTaskWith(request, completionHandler: completionHandler)
    }
    
    func cancelTaskWithUrl(_ url: URL) {
        getAllRunningTasks { (tasks) in
            tasks.filter({ $0.originalRequest?.url == url }).first?.cancel()
        }
    }
    
    func cancelAllAPICalls() {
        getAllRunningTasks { (tasks) in
            _ = tasks.map({ $0.cancel() })
        }
    }
    
    func getAllRunningTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
        let session = AppSession.shared.session
        session.getAllTasks { (tasks) in
            let runningTasks = tasks.filter({ $0.state == .running })
            completionHandler(runningTasks)
        }
    }
    
    // MARK: - Private Methods
    
    private func enqueueRequestWith(_ url: URL, httpMethod: HttpMethod, parameters: [String: Any], headers: [String: String]) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        switch httpMethod {
        case .post:
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            } catch let error {
                print("error while creating post request -> \(error.localizedDescription)")
            }
        case .put:
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            } catch let error {
                print("error while creating put request -> \(error.localizedDescription)")
            }
        case .delete:
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters) {
                request.httpBody = jsonData
            }
        case .get:
            if let encodedURL = URLEncode(url: url, parameters: parameters) {
                request.url = encodedURL
            }
        }
        
        return request
    }
    
    private func enqueueDataTaskWith(_ request: URLRequest, completionHandler: @escaping HttpClientResponseBlock) {
        let dataTask = AppSession.shared.session.dataTask(with: request, completionHandler: { (data, urlResponse, error) -> Void in
            var statusCode = Int.max
            var allHeaderFields = [String: Any]()
            if let httpResponse = urlResponse as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                allHeaderFields = (httpResponse.allHeaderFields as? [String: Any]) ?? [:]
            }
            DispatchQueue.main.async {
                let response = HttpClientResponse(data: data, headers: allHeaderFields, error: error, statusCode: statusCode, url: request.url)
                completionHandler(response)
            }
        })
        dataTask.resume()
    }
    
    // MARK: - Encoding
    
    private func URLEncode(url: URL, parameters: [String: Any] = [:]) -> URL? {
        guard !parameters.isEmpty else {
            return nil
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            return urlComponents.url
        }
        return nil
    }
    
    private func JSONEncode(url: URL, parameters: [String: Any]?) -> Data? {
        guard parameters != nil else {
            return nil
        }
        guard !parameters!.isEmpty else {
            return nil
        }
        return query(parameters!).data(using: .utf8, allowLossyConversion: false)!
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBoolean {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }
    
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
}
