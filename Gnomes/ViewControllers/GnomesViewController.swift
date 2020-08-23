//
//  GnomesViewController.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit

class GnomesViewController: UIViewController {
	var coordinator: GnomeCoordinator?
	let dataSource: TableDataSource<GnomeModel, GnomeTableViewCell>! = TableDataSource()
	
	var gnomes: [GnomeModel] = []
	var filtered: [GnomeModel] = []

	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Brastlewark"
		tableView.dataSource = dataSource
		if gnomes.count > 0 {
			dataSource.items = gnomes
		}
		else {
			gnomes = DBEntitiesApi().getGnomes(town: "Brastlewark")
			dataSource.items = gnomes
		}
    }
	
}

extension GnomesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		coordinator?.showGnome(dataSource.items[indexPath.row])
	}
}

extension GnomesViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard var query = searchController.searchBar.text else { return }
		guard query.count > 0 else {
			filtered = gnomes
			dataSource.items = filtered.sorted {
				switch searchController.searchBar.selectedScopeButtonIndex {
					case 2:
						return $0.age < $1.age
					case 3:
						return $0.age > $1.age
					default:
						return $0.name < $1.name
				}
			}
			tableView.reloadData()
			return
		}
		filtered = gnomes.filter {
			query = query.lowercased()
			switch searchController.searchBar.selectedScopeButtonIndex {
				case 0:
					return $0.name.lowercased().contains(query)
				case 1:
					return $0.professions.map { $0.rawValue }.joined(separator: " ").lowercased().contains(query)
				case 2:
					return $0.age >= Int16(query) ?? 32000
				case 3:
					searchController.searchBar.keyboardType = .numberPad
					return $0.age <= Int16(query) ?? 0
				default:
					print("")
					return false
			}
		}.sorted {
			switch searchController.searchBar.selectedScopeButtonIndex {
				case 2:
					return $0.age < $1.age
				case 3:
					return $0.age > $1.age
				default:
					return $0.name < $1.name
			}
		}
		dataSource.items = filtered
		tableView.reloadData()
	}
	
}

