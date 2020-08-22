//
//  Coordinator.swift
//  Taken from Paul Hudson Coordinators tutorial
//

import UIKit

protocol Coordinator: AnyObject {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }
	func start()
	
	
}

extension Coordinator {
	func presentApiError(message: String?) {
		DispatchQueue.main.async { [weak self] in
			self?.navigationController.present(ErrorAlert.api(message: message ?? "Ocurrió un error inesperado"), animated: true, completion: nil)
		}
	}
	func presentErrorAlert(message: String) {
		navigationController.present(ErrorAlert.userAction(message: message), animated: true, completion: nil)
	}
}
protocol TabCoordinator: Coordinator {
	associatedtype TabController: UITabBarController
	var childCoordinators: [Coordinator] { get set }
	var tabController: TabController? { get set }
}

struct ErrorAlert {
	static func api(message: String) -> UIAlertController {
		let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		return alertVC
	}
	
	static func userAction(message: String) -> UIAlertController {
		let alertVC = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		return alertVC
	}
}
