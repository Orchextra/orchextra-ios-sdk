//
//  SwiftRequestVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 10/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary


class SwiftRequestVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		LogManager.shared.logLevel = .debug
	}
	
	@IBAction func onButtonSwiftRequestTap(_ sender: UIButton) {
		let request = Request(
			method: "POST",
			baseUrl: "https://api-discover-mcd.q.gigigoapps.com",
			endpoint: "/configuration",
			headers: [
				"x-app-version": "IOS_2.1",
				"x-app-country": "BR",
				"x-app-language": "es",
			]
		)
		request.verbose = true
		
		request.fetch(completionHandler: processResponse)
	}
	
	@IBAction func onButtonOrchextraApiRequestTap(_ sender: AnyObject) {
		Request(
			method: "POST",
			baseUrl: "https://api.s.orchextra.io/v1",
			endpoint: "/security/token",
			bodyParams: [
				"grantType": "password",
				"identifier": "test@orchextra.io",
				"password": "12345",
				"staySigned": true,
				"createCookie": false
			],
			verbose: true
		)
		.fetch(completionHandler: processResponse)
	}
		
	@IBAction func onButtonImageDownloadTap(_ sender: AnyObject) {
		Request(
			method: "GET",
			baseUrl: "http://api-discover-mcd.s.gigigoapps.com/media/image/qLXSBtDE/100/185/90?query1=1&query2=2",
			endpoint: "",
			urlParams: [
				"query2": "2",
				"query3": "3"
			],
			verbose: true
		)
		.fetch(completionHandler: processResponse)

	}
    
    @IBAction func onButtonRequestNoGigigoTap(_ sender: AnyObject) {
        Request(
            method: "GET",
            baseUrl: "http://private-3b5b1-ejemplo13.apiary-mock.com/ejemplo13/questions/a",
            endpoint: "",
            verbose: true,
            standard: .basic
            )
            .fetch(completionHandler: processResponse)
    }
	
    @IBAction func onButtonMcdonalLogin(_ sender: AnyObject) {
        var AppHeaders: [String: String] {
            return [
                "X-app-version": "IOS_2.3",
                "X-app-country": "BR",
                "X-app-language": "es"
            ]
        }
        
        let request = Request(
            method: "POST",
            baseUrl: "https://api-discover-mcd.q.gigigoapps.com",
            endpoint: "/security/login",
            headers: AppHeaders,
            bodyParams: [
                "grantType": "password",
                "email" : "eduardo.parada@gigigo.com",
                "password" : "12345",
                "deviceId" : UIDevice.current.identifierForVendor?.uuidString ?? "No identifier"
            ],
            verbose: true
        )
        
        request.fetch { response in
            switch response.status {
                
            case .success:
                print("success")
                break
            case .errorParsingJson:
                print("❌❌❌ errorParsingJson")
                break
            case .sessionExpired:
                print("❌❌❌ sessionExpired")
                break
            case .timeout:
                print("❌❌❌ timeout")
                break
            case .noInternet:
                print("❌❌❌ noInternet")
                break
            case .apiError:
                let dataString = String(data: response.body!, encoding: String.Encoding.utf8)
                print("❌❌❌ apiError code: \(response.error!.code) - dataString: \(String(describing: dataString))")
                break
            case .unknownError:
                print("❌❌❌ unknownError")
                break
            }
        }
    }
		
	fileprivate func processResponse(_ response: Response) {
		switch response.status {

		case .success:
			Log("Success: \n\(String(describing: try? response.json()))")
		case .errorParsingJson, .noInternet, .sessionExpired, .timeout, .unknownError:
			Log("Some kind of error")
			LogError(response.error)
		case .apiError:
			Log("API error")
			LogError(response.error)
		}
        

        
	}
	
}
