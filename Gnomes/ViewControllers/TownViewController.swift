//
//  ViewController.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit
/**
	No se utiliza, pero se desarrollo pensando en que, una mejoría podría ser que se fueran almacenando los pueblos visitados, y cambiarlos en base a la localización virtual =)
*/
class TownViewController: UIViewController {
	let dataSource: TableDataSource<String, TownCell>! = TableDataSource()
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = dataSource
		dataSource.items = DBEntitiesApi().getTowns()

		TownPopulationEndpoint().send { [weak self] (response, error) in
			guard let response = response, error == nil else {
				print(error?.localizedDescription)
				return
			}
			DBEntitiesApi().save(townResponse: response) {
				self?.dataSource.items = DBEntitiesApi().getTowns()
				DispatchQueue.main.async {
					self?.tableView.reloadData()
				}
			}
		}
	}
}

extension TownViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

class TownCell: UITableViewCell, Dequeable {

	func configureFor<T>(element: T) {
		if let townName = element as? String {
			textLabel?.text = townName
		}
	}
}
