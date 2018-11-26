//
//  NetworkRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

class NetworkRequest: ConcurrentOperation {

    enum Method: String {
        case get, post, put, delete
    }

    enum QueryFormat {
        case json
        case urlEncoded
    }

    enum QueryType {
        case body
        case path
    }

    enum RequestError: Error {
        case invalidURL, noHTTPResponse, http(status: Int)

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .noHTTPResponse:
                return "Not a HTTP response."
            case .http(let status):
                return "HTTP error: \(status)."
            }
        }
    }

    var endpoint: String { return "" }
    var method: NetworkRequest.Method { return .get }
    var format: NetworkRequest.QueryFormat { return .urlEncoded }
    var type: NetworkRequest.QueryType { return .path }
    var timeoutInterval = 30.0

    private var task: URLSessionDataTask?
    private var successCodes: CountableRange<Int> = 200..<299
    private var failureCodes: CountableRange<Int> = 400..<499

    // MARK: - Prepare the request

    func prepareURLComponents() -> URLComponents? {
        return URLComponents()
    }

    func prepareParameters() -> [String: Any]? {
        return nil
    }

    func prepareHeaders() -> [String: String]? {
        return nil
    }

    func prepareURLRequest() throws -> URLRequest {
        let parameters = prepareParameters()

        guard let url = prepareURLComponents()?.url else {
            throw RequestError.invalidURL
        }

        switch type {
        case .body:
            var mutableRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            if let parameters = parameters {
                switch format {
                case .json:
                    mutableRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                case .urlEncoded:
                    mutableRequest.httpBody = queryParameters(parameters, urlEncoded: true).data(using: .utf8)
                }
            }
            return mutableRequest

        case .path:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = queryParameters(parameters)
            return URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        }
    }

    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: ".-_")

        var query = ""
        parameters?.forEach { key, value in
            let encodedValue: String
            if let value = value as? String {
                encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
            } else {
                encodedValue = "\(value)"
            }
            query = "\(query)\(key)=\(encodedValue)&"
        }
        return query
    }

    // MARK: - Execute the request

    override func main() {
        guard var request = try? prepareURLRequest() else {
            completeWithError(RequestError.invalidURL)
            return
        }

        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = method.rawValue

        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            self.processResponse(response, data: data, error: error)
        })
        task?.resume()
    }

    override func cancel() {
        task?.cancel()
        super.cancel()
    }

    // MARK: - Process the response

    final func processResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        if let error = error {
            return completeWithError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return completeWithError(RequestError.noHTTPResponse)
        }

        processHTTPResponse(httpResponse, data: data)
    }

    final func processHTTPResponse(_ response: HTTPURLResponse, data: Data?) {
        let statusCode = response.statusCode

        if successCodes.contains(statusCode) {
            processResponseData(data)
        } else if failureCodes.contains(statusCode) {
            if let data = data, let responseBody = try? JSONSerialization.jsonObject(with: data, options: []) {
                debugPrint(responseBody)
            }
            completeWithError(RequestError.http(status: statusCode))
        } else {
            // Server returned response with status code different than expected `successCodes`.
            let info = [
                NSLocalizedDescriptionKey: "Request failed with code \(statusCode)",
                NSLocalizedFailureReasonErrorKey: "Wrong handling logic, wrong endpoing mapping or backend bug."
            ]
            let error = NSError(domain: "NetworkService", code: 0, userInfo: info)
            completeWithError(error)
        }
    }

    func processResponseData(_ data: Data?) {
        completeOperation()
    }

}
