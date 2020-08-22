//
//  Gnome.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.

import Foundation

enum HColor: String, Codable {
	case black = "Black"
	case gray = "Gray"
	case green = "Green"
	case pink = "Pink"
	case red = "Red"
	case unknown = "Unknown"
}

enum Professions: String, Codable {
	case baker = "Baker"
	case blacksmith = "Blacksmith"
	case brewer = "Brewer"
	case butcher = "Butcher"
	case carpenter = "Carpenter"
	case cook = "Cook"
	case farmer = "Farmer"
	case gemcutter = "Gemcutter"
	case leatherworker = "Leatherworker"
	case marbleCarver = "Marble Carver"
	case mason = "Mason"
	case mechanic = "Mechanic"
	case medic = "Medic"
	case metalworker = "Metalworker"
	case miner = "Miner"
	case potter = "Potter"
	case prospector = "Prospector"
	case sculptor = "Sculptor"
	case smelter = "Smelter"
	case stonecarver = "Stonecarver"
	case tailor = "Tailor"
	case taxInspector = "Tax inspector"
	case tinker = " Tinker"
	case woodcarver = "Woodcarver"
}

struct GnomeModel: Codable, Identifiable {
	let id: Int64
	let name: String
	let thumbnail: String
	let age: Int16
	let weight, height: Float
	let hairColor: HColor
	let professions: [Professions]
	let friends: [String]
	
	init(dbModel: Gnome) {
		age = dbModel.age
		friends = (dbModel.friends?.components(separatedBy: ",")) ?? []
		height = dbModel.height
		id = dbModel.id
		name = dbModel.name!
		thumbnail = dbModel.thumbnail!
		weight = dbModel.weight
		
		professions = (dbModel.professions?.allObjects as! [Profession]).compactMap { Professions(rawValue: $0.name!) }
		hairColor = HColor(rawValue: dbModel.hairColor?.color ?? "Unknown") ?? .unknown
	}
}
