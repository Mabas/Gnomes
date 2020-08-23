//
//  GetPopulation.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import Foundation

/**
Si se implementara un json para cada pueblo, se dejó preparado
*/
class TownPopulationEndpoint: Endpoint {
	typealias ResponseType = TownPopulationResponse
	
	var method: Method = .GET
	
	var path: String = "/rrafols/mobile_test/master/"
	
	var town: String
	var request: URLRequest!
	
	init(town: String = "data.json") {
		self.town = town
		let url = "https://raw.githubusercontent.com" + path + town
		request = URLRequest(url: URL(string: url)!)
		request.httpMethod = method.rawValue
	}
	
}
typealias TownPopulationResponse = [String: [GnomeModel]]
