//
//  Request.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

public enum StandardType {
    case gigigo
    case basic
}

open class Request: Selfie {
	
	open var method: String
	open var baseURL: String
	open var endpoint: String
	open var headers: [String: String]?
	open var urlParams: [String: Any]?
	open var bodyParams: [String: Any]?
	open var verbose = false
    open var standardType: StandardType = .gigigo
	
	private var request: URLRequest?
	private var task: URLSessionTask?
	
    // TODO , para versiones futuras borrar este metodo
    public convenience init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, verbose: Bool = false) {
        self.init(
            method: method,
            baseUrl: baseUrl,
            endpoint: endpoint,
            headers: headers,
            urlParams: urlParams,
            bodyParams: bodyParams,
            verbose: verbose,
            standard: .gigigo
        )
    }
    
    public init(method: String, baseUrl: String, endpoint: String, headers: [String: String]? = nil, urlParams: [String: Any]? = nil, bodyParams: [String: Any]? = nil, verbose: Bool = false, standard: StandardType = .gigigo) {
		self.method = method
		self.baseURL = baseUrl
		self.endpoint = endpoint
		self.headers = headers
		self.urlParams = urlParams
		self.bodyParams = bodyParams
		self.verbose = verbose
        self.standardType = standard
	}
	
	open func fetch(completionHandler: @escaping (Response) -> Void) {
		guard let request = self.buildRequest() else { return }
		self.request = request
		let session = URLSession.shared
		
		if self.verbose {
			LogManager.shared.logLevel = .debug
			LogManager.shared.appName = "GIGLibrary"
			self.logRequest()
		}
		
		self.cancel()
		self.task = session.dataTask(with: request) { data, urlResponse, error in
            let response = Response(data: data, response: urlResponse, error: error, standardType: self.standardType)
			
			if self.verbose {
				response.logResponse()
			}
			
			DispatchQueue.main.async {
				completionHandler(response)
			}
		}
		
		self.task?.resume()
	}
	
	public func cancel() {
		self.task?.cancel()
	}
	
	
	// MARK: - Private Helpers
	
	fileprivate func buildRequest() -> URLRequest? {
		guard let url = URL(string: self.buildURL()) else { LogWarn("not a valid URL"); return nil }

		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
		request.httpMethod = self.method
		request.allHTTPHeaderFields = self.headers
		
		// Set body is not GET
		if let body = self.bodyParams, self.method != "GET" {
			request.httpBody = JSON(from: body).toData()
			
			// Add Content-Type if it wasn't set
			if let containsContentType = request.allHTTPHeaderFields?.keys.contains("Content-Type"),
				!containsContentType {
				request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			}
		}
		
		return request
	}
	
    fileprivate func buildURL() -> String {
        var url = URLComponents(string: self.baseURL)        
        url?.path += self.endpoint
        
        if let urlParams = self.urlParams?.map({ key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }) {
            let urlConcat = concat(url?.queryItems, urlParams)
            url?.queryItems = urlConcat
        }
        
        return url?.string ?? "NOT VALID URL"
    }
	
	fileprivate func logRequest() {
		let url = self.request?.url?.absoluteString ?? "no url set"
		let method = self.request?.httpMethod ?? "no method set"
		
		print("******** REQUEST ********")
		print(" - URL:\t\t\(url)")
		print(" - METHOD:\t\(method)")
		self.logBody()
		self.logHeaders()
		print("*************************\n")
	}
	
	fileprivate func logBody() {
		guard
			let body = self.request?.httpBody,
			let json = try? JSON.dataToJson(body)
			else { return }
		
		print(" - BODY:\n\(json)")
	}
	
	fileprivate func logHeaders() {
		guard let headers = self.request?.allHTTPHeaderFields, !headers.isEmpty else { return }
		
		print(" - HEADERS: {")
		
		for key in headers.keys {
			if let value = headers[key] {
				print("\t\t\(key): \(value)")
			}
		}
		
		print("}")
	}
	
}


func concat(_ lhs: [URLQueryItem]?, _ rhs: [URLQueryItem]?) -> [URLQueryItem] {
	guard let left = lhs else {
		return rhs ?? []
	}
	
	guard let right = rhs else {
		return left
	}
	
	return left + right
}
