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
		case Mention
	}
	let context = CDStack.shared.managedObjectContext

	func save(townResponse: TownPopulationResponse, completion: () -> Void) {
		
		townResponse.forEach { (townName, gnomes) in
			//A menos que la population sea dinamica, evitamos que se recree el town
			guard getTown(town: townName) == nil else {
				return
			}
			
			let townEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Town.rawValue, into: context) as! Town
			townEntity.name = townName
			
			let gnomeEntities: [Gnome] = gnomes.compactMap { (gnome) in
				if let gnomeEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Gnome.rawValue, into: context) as? Gnome {
					gnomeEntity.set(from: gnome)
					gnomeEntity.setProfessions(gnome.professions)
					addMention(name: gnome.name)

					gnome.friends.forEach {
						addMention(name: $0)
					}
					
					do {
						let hColor = try DBEntitiesApi().getOrCreate(hairColor: gnome.hairColor)
						hColor.addToGnomes(gnomeEntity)
					}
					catch {
						print("Can't set hairColor")
					}
					return gnomeEntity
				}
				else {
					print("No se genero entidad Gnome")
				}

				return nil
			}
			townEntity.addToGnomes(NSOrderedSet(array: gnomeEntities))
			CDStack.shared.saveContext()

		}
		context.reset()
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
		if let professionEntity = getProfession(profession) {
			return professionEntity
		}
		else {
			let professionEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Profession.rawValue, into: context) as! Profession
			professionEntity.name = profession.rawValue
			return professionEntity
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
	
	func addMention(name: String) {
		let fetchRequest: NSFetchRequest<Mention> = Mention.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name == %@", name)
		fetchRequest.fetchLimit = 1
		do {
			let resultados = try context.fetch(fetchRequest)
			if let mention = resultados.first {
				mention.count += 1
			}
			else {
				let mentionEntity = NSEntityDescription.insertNewObject(forEntityName: Entities.Mention.rawValue, into: context) as! Mention
				mentionEntity.name = name
				mentionEntity.count = 0
			}
		}
		catch {
			print("No se pudo agregar mención")
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
	
	func getGnomes(profession: Professions) -> [GnomeModel] {
		if let professionEntity = getProfession(profession) {
			let gnomes = professionEntity.gnomes?.allObjects as! [Gnome]
			return gnomes.map {
				GnomeModel(dbModel: $0)
			}
		}
		return []
	}
	
	func getProfession(_ profession: Professions) -> Profession? {
		let fetchRequest: NSFetchRequest<Profession> = Profession.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name == %@", profession.rawValue)
		fetchRequest.fetchLimit = 1
		let resultados = try? context.fetch(fetchRequest)
		if let professionEntity = resultados?.first {
			return professionEntity
		}
		return nil
	}
	
	func getGnome(name: String) -> GnomeModel? {
		let fetchRequest: NSFetchRequest<Gnome> = Gnome.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name == %@", name)
		fetchRequest.fetchLimit = 1
		let resultados = try? context.fetch(fetchRequest)
		if let gnomeEntity = resultados?.first {
			return  GnomeModel(dbModel: gnomeEntity)
		}
		return nil
	}
	
	func getProfessions() -> [String: Int] {
		let fetchRequest: NSFetchRequest<Profession> = Profession.fetchRequest()
		let resultados: [Profession] = (try? context.fetch(fetchRequest)) ?? []
		var dict = [String: Int]()
		resultados.forEach { dict[$0.name!] = $0.objectIDs(forRelationshipNamed: "gnomes").count }
		return dict
	}
	
	func getHairColors() -> [String: Int] {
		let fetchRequest: NSFetchRequest<HairColor> = HairColor.fetchRequest()
		let resultados: [HairColor] = (try? context.fetch(fetchRequest)) ?? []
		var dict = [String: Int]()
		resultados.forEach { dict[$0.color!] = $0.objectIDs(forRelationshipNamed: "gnomes").count }
		return dict
	}
	
	func getMentions() -> [String: Int] {
		let fetchRequest: NSFetchRequest<Mention> = Mention.fetchRequest()
		let resultados: [Mention] = (try? context.fetch(fetchRequest)) ?? []
		var dict = [String: Int]()
		resultados.forEach { dict[$0.name!] = Int($0.count) }
		return dict
	}
	
	func getGnomes() -> [GnomeModel] {
		let fetchRequest: NSFetchRequest<Gnome> = Gnome.fetchRequest()
		let resultados: [Gnome] = (try? context.fetch(fetchRequest)) ?? []
		return resultados.map { GnomeModel(dbModel: $0) }
	}
}

extension Gnome {
	func set(from gnome: GnomeModel) {
		age = gnome.age
		friends = gnome.friends.count > 0 ? gnome.friends.joined(separator: ",") : nil
		height = gnome.height
		id = gnome.id
		name = gnome.name
		thumbnail = gnome.thumbnail
		weight = gnome.weight
	}
	
	func setProfessions(_ professions: [Professions]) {
		let _: [Profession] = professions.compactMap { (profession) in
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
	}
}
