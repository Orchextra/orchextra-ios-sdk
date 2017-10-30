//
//  NSManagedObjectContext+Extension.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 14/3/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public extension NSManagedObjectContext {
	
	public func createEntity(_ name: String) -> NSManagedObject? {
		guard let entity = NSEntityDescription.entity(forEntityName: name, in: self) else {
			return nil
		}
		
		return NSManagedObject(entity: entity, insertInto: self)
	}
	
	public func fetchFirst(_ entityName: String, predicateString: String) -> NSManagedObject? {
		let result = self.fetchList(entityName, predicateString: predicateString)
		return result?.first
	}
	
	public func fetchList(_ entityName: String, predicateString: String) -> [NSManagedObject]? {
        let fetch : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
		fetch.predicate = NSPredicate(format: predicateString)
		
		let results = try? self.fetch(fetch)
		
		return results as? [NSManagedObject]
	}
}
