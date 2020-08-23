//
//  GnomesCoordinator.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit
/**
Coordinador encargado del flujo de la aplicación en lo referente a gnomos
*/
class GnomeCoordinator: Coordinator {
	weak var parentCoordinator: MainCoordinator?
	
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		
	}
	
	func showGnome(_ gnome: GnomeModel) {
		let vc = GnomeDetailViewController.instantiate()
		vc.coordinator = self
		vc.gnome = gnome
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showProfession(_ profession: Professions) {
		let vc = GnomesViewController.instantiate()
		vc.coordinator = self
		vc.gnomes = DBEntitiesApi().getGnomes(profession: profession)
		vc.title = "\(profession.rawValue) Gnomes"
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showFriend(_ friend: String) {
		let vc = GnomeDetailViewController.instantiate()
		vc.coordinator = self
		vc.gnome = DBEntitiesApi().getGnome(name: friend)
		navigationController.pushViewController(vc, animated: true)
	}
}
