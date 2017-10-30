//
//  ImageDownloader.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/11/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

struct ImageDownloader {
	
	static let shared = ImageDownloader()
	static var queue: [UIImageView: Request] = [:]
	static var stack: [UIImageView] = []
	static var images: [String: UIImage] = [:]
	
	
	init() {
		NotificationCenter.default.addObserver(forName: .UIApplicationDidReceiveMemoryWarning, object: nil, queue: nil) { _ in
			ImageDownloader.images.removeAll()
			ImageDownloader.stack.removeAll()
			ImageDownloader.queue.removeAll()
		}
	}
	
	// MARK: - Public methods
	
	func download(url: String, for view: UIImageView, placeholder: UIImage?) {
		if let request = ImageDownloader.queue[view] {
			request.cancel()
			ImageDownloader.queue.removeValue(forKey: view)
		}
		
		if let image = ImageDownloader.images[url] {
			view.image = image
		} else {
			view.image = placeholder
			self.loadImage(url: url, in: view)
		}
	}
	
	
	// MARK: - Private Helpers
	
	private func loadImage(url: String, in view: UIImageView) {
		let request = Request(method: "GET", baseUrl: url, endpoint: "")
		ImageDownloader.queue[view] = request
		ImageDownloader.stack.append(view)
		
		if ImageDownloader.queue.count <= 3 {
			self.downloadNext()
		}
	}
	
	private func downloadNext() {
		guard let view = ImageDownloader.stack.popLast() else { return }
		guard let request = ImageDownloader.queue[view] else { return }
		
		request.fetch { response in
			switch response.status {
				
			case .success:
				DispatchQueue.global().async {
					if let image = try? response.image() {
						
						DispatchQueue.main.sync {
                            
                            let width = view.width() * UIScreen.main.scale
                            let height = view.height() * UIScreen.main.scale
                            let resized = image.imageProportionally(with: CGSize(width: width, height: height))
                            ImageDownloader.images[request.baseURL] = resized

							if let currentRequest = ImageDownloader.queue[view], request.baseURL == currentRequest.baseURL {
								self.setAnimated(image: resized, in: view)
							}
							
							if let index = ImageDownloader.queue.index(forKey: view) {
								ImageDownloader.queue.remove(at: index)
							}
							self.downloadNext()
						}
					} else {
						self.downloadNext()
					}
				}
				
			default:
				LogError(response.error)
				self.downloadNext()
			}
		}
	}
	
	private func setAnimated(image: UIImage?, in view: UIImageView) {
		UIView.transition(
			with: view,
			duration:0.4,
			options: .transitionCrossDissolve,
			animations: {
				view.image = image
		},
			completion: nil
		)
	}
	
}
