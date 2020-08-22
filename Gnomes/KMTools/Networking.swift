//
//  Networking.swift
//  KMTools
//
//  Created by mabas on 13/07/20.
//  Copyright © 2020 Kmabas. All rights reserved.
//

import Foundation

enum Method: String{
	case GET, POST , DELETE, PUT
}

protocol Endpoint: AnyObject {
	associatedtype ResponseType: Decodable
	
	var request: URLRequest! { get set }
	var method: Method { get set }
	var path: String { get set }
	
	
	func params<T: Encodable>(_ params: T)
	func headers(_ headers: [Header])
	
	func decode(data: Data) -> ResponseType?
}


struct Header {
	let name: String
	let value: String
}

enum APIError: Error {
	case undecodable
	
}

extension Endpoint {
	func decode(data: Data) -> ResponseType? {
		do {
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase

			return try decoder.decode(ResponseType.self, from: data)
		}
		catch {
			print("No se pudo convertir al tipo \(ResponseType.self)")
			print(error)
		}
		return nil
	}
	func queryParams(_ params: [String: Any]) {
		var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
		components?.queryItems = params.map {
			URLQueryItem(name: $0, value: String(describing: $1))
		}
		request.url = components?.url
	}
	func params<T: Encodable>(_ params: T) {
		print(params)
		
		request.httpBody  = try? JSONEncoder().encode(params)
		request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
	}
	
	func headers(_ headers: [Header]) {
		headers.forEach {
			request.setValue($0.value, forHTTPHeaderField: $0.name)
		}
	}
	
	func send(completion: @escaping(_ object: ResponseType?, _ error: Error?) -> Void) {
		debugPrint("enviando \(String(describing: request.url))")
		let session = URLSession(configuration: .default)
		let task = session.dataTask(with: request) { (data, response, error) in
			if error != nil {
				completion(nil, error)
			}
			else if let data = data {
				if let httpResponse = response as? HTTPURLResponse {
					debugPrint(httpResponse.statusCode)
				}
				if let responseObject = self.decode(data: data) {
					completion(responseObject, nil)
				}
				else {
					completion(nil, APIError.undecodable)
				}
			}
		}
		task.resume()
	}
}

protocol Response: Decodable {
	var success: Bool { get set }
	var message: String { get set }
}
