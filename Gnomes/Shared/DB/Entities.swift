//
//  Entities.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import Foundation
import CoreData

class DBEntitiesApi {
	enum Entities: String {
		case Town
		case Gnome
		case Profession
		case HairColor
	}
	let context = CDStack.shared.context

	func save(townResponse: TownPopulationResponse, completion: () -> Void) {
		
		townResponse.forEach { (townName, gnomes) in
			//A menos que la population sea dinamica, evitamos que se recree el town
			guard getTown(town: townName) == nil else {
				return
			}
			
			let townEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Town.rawValue, into: context) as! Town
			townEntity.name = townName
			
			let gnomeEntities: [Gnome] = gnomes.map { (gnome) in

				let gnomeEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Gnome.rawValue, into: context) as! Gnome

				gnomeEntity.set(from: gnome)
				gnomeEntity.town = townEntity
				return gnomeEntity
			}
			townEntity.addToGnomes(NSOrderedSet(array: gnomeEntities))
			
		}
		CDStack.shared.saveContext()
		completion()
	}
	
	func getTowns() -> [String] {
		let fetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
		let resultados = try? context.fetch(fetchRequest)
		return resultados?.compactMap{
			return $0.name
			} ?? []
		
	}
	
	func getTown(town: String) -> Town? {
		let fetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name == %@", town)
		fetchRequest.fetchLimit = 1
		let resultados = try? context.fetch(fetchRequest)
		if let townEntity = resultados?.first {
			return townEntity
		}
		return nil
	}
	
	func getOrCreate(profession: Professions) throws -> Profession {
		let fetchRequest: NSFetchRequest<Profession> = Profession.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name == %@", profession.rawValue)
		fetchRequest.fetchLimit = 1
		do {
			let resultados = try context.fetch(fetchRequest)
			if let professionEntity = resultados.first {
				return professionEntity
			}
			else {
				let professionEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Profession.rawValue, into: context) as! Profession
				professionEntity.name = profession.rawValue
				return professionEntity
			}
		}
	}
	
	func getOrCreate(hairColor: HColor) throws -> HairColor {
		let fetchRequest: NSFetchRequest<HairColor> = HairColor.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "color == %@", hairColor.rawValue)
		fetchRequest.fetchLimit = 1
		do {
			let resultados = try context.fetch(fetchRequest)
			if let hairColorEntity = resultados.first {
				return hairColorEntity
			}
			else {
				let hairColorEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.HairColor.rawValue, into: context) as! HairColor
				hairColorEntity.color = hairColor.rawValue
				return hairColorEntity
			}
		}
	}
	
	func getGnomes(town: String) -> [GnomeModel] {
		if let townEntity = getTown(town: town),
			let gnomes = townEntity.gnomes?.array as? [Gnome] {
			return gnomes.map {
				GnomeModel(dbModel: $0)
			}
		}
		else {
			return []
		}
	}
}

extension Gnome {
	func set(from gnome: GnomeModel) {
		age = gnome.age
		friends = gnome.friends.joined(separator: ",")
		height = gnome.height
		id = gnome.id
		name = gnome.name
		thumbnail = gnome.thumbnail
		weight = gnome.weight

		
		/*do {
			let hColor = try DBEntitiesApi().getOrCreate(hairColor: gnome.hairColor)
			hColor.addToGnomes(self)
			self.hairColor = hColor
		}
		catch {
			print("Can't set hairColor")
		}
		setProfessions(gnome.professions)
*/
	}
	func setProfessions(_ professions: [Professions]) {
		let professionEntities: [Profession] = professions.compactMap { (profession) in
			do {
				let prof = try DBEntitiesApi().getOrCreate(profession: profession)
				prof.addToGnomes(self)
				return prof
			}
			catch {
				print("No se pudo asignar la profesion")
			}
			return nil
		}
		addToProfessions(NSSet(array: professionEntities))
	}
}
