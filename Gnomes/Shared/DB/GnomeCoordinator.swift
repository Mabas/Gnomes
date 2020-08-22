//
//  GnomesCoordinator.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit

class GnomeCoordinator: Coordinator {
	weak var parentCoordinator: MainCoordinator?
	
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = GnomeDetailViewController.instantiate()
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: false)
	}
	
}




