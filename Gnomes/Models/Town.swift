//
//  Town.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import Foundation

struct Town: Codable {
	let id: Int
	let name: String
	let thumbnail: String
	let age: Int
	let weight, height: Double
	let hairColor: HairColor
	let professions: [Profession]
	let friends: [String]
	
}
