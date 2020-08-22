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
	
	var gnomes: [GnomeModel]?

	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.dataSource = dataSource
		if let gnomes = gnomes {
			dataSource.items = gnomes
		}
		else {
			dataSource.items = DBEntitiesApi().getGnomes(town: "Brastlewark")
		}
    }
}

extension GnomesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		coordinator?.showGnome(dataSource.items[indexPath.row])
	}
}
