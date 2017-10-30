//
//  Instantiator.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 22/8/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

public enum ErrorInstantiation: Error {
    case instantiateFromIdentifier
    case instantiateIntial
}

public protocol Instantiable {
    static var storyboard: String {get}
    static var bundle: Bundle {get}
    static var identifier: String {get}
}

public extension Instantiable where Self: UIViewController {
    static var identifier: String { get{ return "" } }
    static var bundle: Bundle { get{ return Bundle(for: Self.self) } }
}

public extension Instantiable {
    
    /**
     Instantiate the ViewController
     
     - throws: An error of type ErrorInstantiation
     - returns: A ViewController object (already downcasted)
     - Author: Alejandro Jiménez
     - Version: 2.1.4
     - Since: 1.2.1
     */
    
    public static func instantiateFromStoryboard() throws -> Self {
        let bundle = Self.bundle
        let storyboard = UIStoryboard(name: Self.storyboard, bundle: bundle)
        var viewController: UIViewController?
        
        if Self.identifier.characters.count > 0 {
            viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        } else {
            guard let vc = storyboard.instantiateInitialViewController() else {
                LogWarn("Could not instantiate the initial view controller from storyboard: \(Self.storyboard)")
                throw ErrorInstantiation.instantiateIntial
            }
            viewController = vc
        }
        
        guard let downcastedVC = viewController as? Self else {
            LogWarn("Could not instantiate view controller from storyboard: \(Self.storyboard), identifier: \(String(describing: identifier))")
            throw ErrorInstantiation.instantiateFromIdentifier
        }
        return downcastedVC
    }
}

