//
//  Response.swift
//  MCDonald
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public let kGIGNetworkErrorDomain = "com.gigigo.network";
public let kGIGNetworkErrorMessage = "GIGNETWORK_ERROR_MESSAGE"


public enum ResponseStatus {
	case success
	case errorParsingJson
	case sessionExpired
	case timeout
	case noInternet
	case apiError
	case unknownError
}

open class Response: Selfie {
	
	open var status: ResponseStatus
	open var statusCode: Int
	open var url: URL?
	open var headers: [AnyHashable: Any]?
	open var body: Data?
	open var data: JSON?
	open var error: NSError?
    var standardType: StandardType = .gigigo
	
	
	// MARK: - Initializers
	
	init() {
		self.status = .unknownError
		self.statusCode = 0
	}
	
    convenience init(data: Data?, response: URLResponse?, error: Error?, standardType: StandardType = .gigigo) {
		self.init()
		
        self.standardType = standardType
		self.error = error as NSError?
		if let response = response as? HTTPURLResponse {
			self.url = response.url
			self.headers = response.allHeaderFields
			self.body = data
			self.statusCode = response.statusCode
			
			if (200...300).contains(self.statusCode) {
				self.status = .success
			}
			
			if let contentType = self.headers?["Content-Type"] as? String,
				contentType.contains("json"){
                self.parseJSON()
			}
		} else {
			self.statusCode = self.error?.code ?? -1
			self.status = self.parseError(error: self.error)
		}
	}
	
	
	// MARK: - Private Helpers
    
	private func parseJSON() {
		guard
			let body = self.body,
			let json = try? JSON.dataToJson(body)
			else { return LogWarn("Response is not a JSON") }
		
        
        switch self.standardType {
        case .gigigo:
            let success = self.parseStatus(json: json)
            if success {
                self.status = .success
                self.data = json["data"]
            } else {
                self.status = self.parseError(json: json)
            }
        case .basic:
            self.data = json
        }
	}
	
	private func parseStatus(json: JSON) -> Bool {
		if let statusBool = json["status"]?.toBool() {
			return statusBool
		} else if let statusString = json["status"]?.toString() {
			return statusString == "OK"
		} else {
			return false
		}
	}
	
	private func parseError(json: JSON) ->  ResponseStatus {
		let error = json["error"]
		
		guard
			let code = error?["code"]?.toInt(),
			let message = error?["message"]?.toString()
			else { return self.parseError(error: self.error) }
		
		let userInfo = [kGIGNetworkErrorMessage: message]
		self.error = NSError(domain: kGIGNetworkErrorDomain, code: code, userInfo: userInfo)
		
		return self.parseError(error: self.error)
	}
	
	fileprivate func parseError(error: NSError?) -> ResponseStatus {
		guard let err = error else { return .unknownError }
		
		self.statusCode = err.code
		
		switch err.code {
		case 401:
			return .sessionExpired
		case -1001:
			return .timeout
		case -1009:
			return .noInternet
		case 10000...20000:
			return .apiError
		default:
			return .unknownError
		}
	}
	
	func logResponse() {
		print("******** RESPONSE ********")
		print(" - URL:\t" + self.logURL())
		print(" - CODE:\t" + "\(self.statusCode)")
		self.logHeaders()
		self.logData()
		print("*************************\n")
	}
	
	private func logURL() -> String {
		guard let url = self.url?.absoluteString else {
			return "NO URL"
		}
		
		return url
	}
	
	private func logHeaders() {
		guard let headers = self.headers else { return }
		
		print(" - HEADERS: {")
		
		for key in headers.keys {
			if let value = headers[key] {
				print("\t\t\(key): \(value)")
			}
		}
		
		print("}")
	}
	
	private func logData() {
		guard let body = self.body else {
			return
		}
		
		if let json = try? JSON.dataToJson(body) {
			print(" - JSON:\n\(json)")
		} else if let string = String(data: body, encoding: .utf8) {
			print(" - DATA:\n\(string)")
		}
		
	}
}


public enum ResponseError: Error {
	case bodyNil
	case unexpectedDataType
}

public extension Response {
	
	public func json() throws -> JSON {
		guard let json = self.data else {
			throw ResponseError.bodyNil
		}
		
		return json
	}
	
	public func image() throws -> UIImage {
		guard let imageData = self.body else {
			throw ResponseError.bodyNil
		}
		
		guard let image = UIImage(data: imageData, scale: UIScreen.main.scale) else {
			throw ResponseError.unexpectedDataType
		}
		
		return image
	}
	
}
