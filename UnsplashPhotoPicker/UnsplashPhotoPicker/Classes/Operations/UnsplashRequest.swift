//
//  UnsplashRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

class UnsplashRequest: NetworkRequest {

    enum RequestError: Error {
        case invalidJSONResponse

        var localizedDescription: String {
            switch self {
            case .invalidJSONResponse:
                return "Invalid JSON response."
            }
        }
    }

    private(set) var jsonResponse: Any?

    // MARK: - Prepare the request

    override func prepareURLComponents() -> URLComponents? {
        guard let apiURL = URL(string: Configuration.shared.apiURL) else {
            return nil
        }

        var urlComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint
        return urlComponents
    }

    override func prepareParameters() -> [String: Any]? {
        return nil
    }

    override func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(Configuration.shared.accessKey)"
        return headers
    }

    // MARK: - Process the response

    override func processResponseData(_ data: Data?) {
        if let error = error {
            completeWithError(error)
            return
        }

        guard let data = data else { return }

        do {
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            processJSONResponse()
        } catch {
            completeWithError(RequestError.invalidJSONResponse)
        }
    }

    func processJSONResponse() {
        if let error = error {
            completeWithError(error)
        } else {
            completeOperation()
        }
    }
}
