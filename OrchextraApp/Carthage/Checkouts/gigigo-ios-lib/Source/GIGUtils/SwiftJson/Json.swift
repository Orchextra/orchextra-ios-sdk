//
//  Json.swift
//  AlwaysOn
//
//  Created by Alejandro Jiménez Agudo on 22/2/16.
//  Copyright © 2016 Gigigo S.L. All rights reserved.
//

import Foundation


open class JSON: Sequence, CustomStringConvertible {
	
	private var json: Any
	
	open var description: String {
		if let data = try? JSONSerialization.data(withJSONObject: self.json, options: .prettyPrinted) as Data {
			if let description = String(data: data, encoding: String.Encoding.utf8) {
				return description
			}
			else {
				return String(describing: self.json)
			}
		}
		else {
			return String(describing: self.json)
		}
	}
	
	
	// MARK - Initializers
	
	public init(from any: Any) {
		self.json = any
	}
	
	open subscript(path: String) -> JSON? {
		get {
			guard var jsonDict = self.json as? [String: Any] else {
				return nil
			}
			
			var json = self.json
			let pathArray = path.components(separatedBy: ".")
			
			for key in pathArray {
				
				if let jsonObject = jsonDict[key] {
					json = jsonObject
					
					if let jsonDictNext = jsonObject as? [String : Any] {
						jsonDict = jsonDictNext
					}
				}
				else {
					return nil
				}
			}
			
			return JSON(from: json)
		}
	}
    
    open subscript(index: Int) -> JSON? {
        get {
            guard let array = self.json as? [Any] , array.count > index else { return nil }
            
            return JSON(from: array[index])
        }
    }
	
	open class func dataToJson(_ data: Data) throws -> JSON {
		let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
		let json = JSON(from: jsonObject)
		
		return json
	}
	
	
	// MARK - Public methods
	
	open func toData() -> Data? {
		do {
			let data = try JSONSerialization.data(withJSONObject: self.json)
			return data
		}
		catch let error as NSError {
			LogError(error)
			return nil
		}
	}
	
	open func toBool() -> Bool? {
		return self.json as? Bool
	}
		
	open func toInt() -> Int? {
		if let value = self.json as? Int {
			return value
		}
		else if let value = self.toString() {
			return Int(value)
		}
		
		return nil
	}
		
	open func toString() -> String? {
		return self.json as? String
	}
	
	open func toDate(_ format: String = DateISOFormat) -> Date? {
		guard let dateString = self.json as? String else {
			return nil
		}
		
		return Date.dateFromString(dateString, format: format)
	}
    
    open func toDouble() -> Double? {
        return self.json as? Double
    }
    
    open func toDictionary() -> [String: Any]? {
        
        guard let dic = self.json as? [String: Any] else {
            return [:]
        }
        
        return dic
    }
    
    open func toArray() -> [Any]? {
        guard let array = self.json as? [Any] else {
            return []
        }
        
        return array
    }
	
	// MARK - Sequence Methods
	
	open func makeIterator() -> AnyIterator<JSON> {
		var index = 0
		
		return AnyIterator{ () -> JSON? in
			guard let array = self.json as? [Any] else { return nil }
			guard array.count > index else { return nil }
			
			let item = array[index]
			let json = JSON(from: item)
			index += 1
			
			return json
		}
	}
}
