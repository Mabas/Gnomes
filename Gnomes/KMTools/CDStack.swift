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
		let container = NSPersistentContainer(name: "GnomesCoreData")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		persistentContainer = container
		managedObjectContext = container.newBackgroundContext()
	}
		// MARK: - Core Data stack
	var persistentContainer: NSPersistentContainer
	// MARK: - Core Data Saving support
	func saveContext () {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	let managedObjectContext: NSManagedObjectContext
}
