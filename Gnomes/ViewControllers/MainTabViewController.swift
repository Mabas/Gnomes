//
//  MainTabViewController.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit

/**
Dado que uno de los requisitos era fast filtering, se implemento el SearchController en el Tab, para que estuviera disponible en las 2 pantallas principales, aunque el filtrado se realiza en GnomesViewController, por eso se definió este como searchResultsUpdater
*/
class MainTabViewController: UITabBarController {
	weak var coordinator: MainCoordinator?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Brastlewark"


		//Obtener los tabbed usados
	}
	func configureSearch() {
		let search = UISearchController(searchResultsController: nil)
		search.searchResultsUpdater = viewControllers?.first as? GnomesViewController
		search.delegate = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search by..."
		search.searchBar.scopeButtonTitles = ["Name", "Profession", "Older", "Younger"]
		search.searchBar.delegate = self
		search.automaticallyShowsScopeBar = true
		navigationItem.searchController = search
	}
}


extension MainTabViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		selectedIndex = 0
		if selectedScope < 2 {
			searchBar.keyboardType = .default
		}
		else {
			searchBar.keyboardType = .numberPad
		}
		searchBar.text = ""
		searchBar.reloadInputViews()
	}
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		selectedIndex = 0
		return true
	}
}

/**
Realizar el cambio a la primera vista, para mostrar los resultados
*/
extension MainTabViewController: UISearchControllerDelegate {
	func willPresentSearchController(_ searchController: UISearchController) {
		selectedIndex = 0
	}
	
}

