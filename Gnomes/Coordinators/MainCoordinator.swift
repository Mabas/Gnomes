//
//  MainCoordinator.swift
//

import UIKit

class MainCoordinator: NSObject, TabCoordinator {
	typealias TabController = MainTabViewController
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	
	var tabController: MainTabViewController?
	
	override init() {
		tabController = MainTabViewController.instantiate()
		navigationController = UINavigationController(rootViewController: tabController!)
		super.init()
		tabController?.coordinator = self
	}
	
	func start() {
		navigationController.delegate = self
		tabController?.delegate = self
		
		setTabs()

		let towns = DBEntitiesApi().getTowns()
		if towns.count == 0 {
			TownPopulationEndpoint().send { [weak self] (response, error) in
				guard let response = response, error == nil else {
					print(error?.localizedDescription ?? "No se obtuvo respuesta")
					return
				}
				DBEntitiesApi().save(townResponse: response) {
					DispatchQueue.main.async {
						self?.setTabs()
					}
				}
			}
		}
		else {
			setTabs()
		}
		
	}
	
	func setTabs() {
		var tabs = [UIViewController]()
		let gnomesCoordinator = GnomeCoordinator(navigationController: navigationController)
		tabs.append(gnomesTab(gnomesCoordinator: gnomesCoordinator))
		tabs.append(statisticsTab(gnomesCoordinator: gnomesCoordinator))
		tabController?.viewControllers = tabs
		tabController?.configureSearch()
	}
	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() {
			if coordinator === child {
				childCoordinators.remove(at: index)
				break
			}
		}
	}
	
	
	
}

extension MainCoordinator: UITabBarControllerDelegate {
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		
	}
}

extension MainCoordinator: UINavigationControllerDelegate {
	
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		// Read the view controller we’re moving from.
		guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
			return
		}
		
	}
}

extension MainCoordinator {
	
	func gnomesTab(gnomesCoordinator: GnomeCoordinator) -> UIViewController {
		let gnomesVC = GnomesViewController.instantiate()
		childCoordinators.append(gnomesCoordinator)
		gnomesVC.coordinator = gnomesCoordinator
		return gnomesVC
	}
	
	func statisticsTab(gnomesCoordinator: GnomeCoordinator) -> UIViewController {
		let statisticsVC = StatisticsViewController.instantiate()
		childCoordinators.append(gnomesCoordinator)
		statisticsVC.coordinator = gnomesCoordinator
		return statisticsVC
	}
	
}
