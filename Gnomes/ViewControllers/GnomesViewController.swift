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

	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.dataSource = dataSource
		dataSource.items = DBEntitiesApi().getGnomes(town: "Brastlewark")
		
    }
    

}
