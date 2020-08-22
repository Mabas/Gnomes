//
//  CDStack.swift
//
//
//  Created by mabas on 25/07/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import Foundation

import CoreData
final class CDStack {
	static let shared = CDStack()
	fileprivate init() {
		
	}
		// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "GnomesCoreData")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	var context: NSManagedObjectContext {
		//persistentContainer.viewContext.refreshAllObjects()
		return persistentContainer.viewContext
	}
}
