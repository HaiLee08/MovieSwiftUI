//
//  NetworkClient.swift
//  Mobile App
//
//  Created by Hai Le on 3/15/23.
//

import Foundation

class NetworkClient {
    // MARK: - Properties
    var hostname: String
    
    lazy var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return configuration
    }()
    
    lazy var session: URLSession = {
        let session = URLSession(configuration: self.configuration, delegate: nil, delegateQueue: .main)
        return session
    }()
    
    // MARK: - Init
    init(hostname: String) {
        self.hostname = hostname
    }

    // MARK: - Deinit
    deinit {
        session.invalidateAndCancel()
    }

    // MARK: - Request Options
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }

    // MARK: - URL Components
    private var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = hostname
        return components
    }
    
    private func urlComponents(for uri: String, queryItems: [URLQueryItem]? = nil) -> URLComponents {
        var urlComponents = baseURLComponents
        urlComponents.path = uri
        if queryItems != nil {
            var allQueryItems = [URLQueryItem]()
            if let queryItems = queryItems {
                allQueryItems += queryItems
            }
            urlComponents.queryItems = allQueryItems
        }
        return urlComponents
    }
    // MARK: - Errors
    enum RequestError: Error {
        case error(request: URLRequest, error: Error)
        case nilResponse(request: URLRequest)
        case invalidResponse(request: URLRequest, response: URLResponse)
    }

    // MARK: - Results
    struct RequestResult {
        let request: URLRequest
        let response: HTTPURLResponse
        let data: Data
    }

    // MARK: - Outcomes
    typealias RequestResponse = Swift.Result<RequestResult, RequestError>
    
    func authorization() -> String? {
        return nil
    }
    
    // MARK: - URLRequests
    private func makeRequest(url: URL, cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeInterval = 60.0) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorizationValue = self.authorization() {
            request.setValue(authorizationValue, forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    // MARK: - Base Requests
    func request(url: URL, httpMethod: HttpMethod, data: Data? = nil) async throws -> RequestResponse {
        var outcome: RequestResponse
        var request = self.makeRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = data
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                outcome = .failure(.invalidResponse(request: request, response: response))
                return outcome
            }
            outcome = .success(RequestResult(request: request, response: urlResponse, data: data))
            return outcome
        } catch let error {
            outcome = .failure(.error(request: request, error: error))
            return outcome
        }
        
    }

    func request(_ uri: String, queryItems: [URLQueryItem]? = nil, httpMethod: HttpMethod, data: Data? = nil) async throws -> RequestResponse {
        let url = urlComponents(for: uri, queryItems: queryItems).url
        let outcome = try await request(url: url!, httpMethod: httpMethod, data: data)
        return outcome
    }
    
    func get(_ uri: String, queryItems: [URLQueryItem]? = nil) async throws -> RequestResponse {
        let outcome = try await request(uri, queryItems: queryItems, httpMethod: .get)
        return outcome
    }

    func post(_ uri: String, queryItems: [URLQueryItem]? = nil, data: Data? = nil) async throws -> RequestResponse {
        let outcome = try await request(uri, queryItems: queryItems, httpMethod: .post, data: data)
        return outcome
    }
}
