//  KMTools
//  based on Paul Hudson tutorial
//  Created by mabas on 13/07/20.
//  Copyright © 2020 Kmabas. All rights reserved.
//

import UIKit

protocol DataSource {
	associatedtype Cell: Dequeable
	associatedtype Item: Any

	var items: [Item] { get set }
	
	var cellOutput: CellOutput? { get set }
}

protocol CellOutput {
	func configuredCell<T>(_ cell: T)
}

class TableDataSource<Item, CellClass: Dequeable>: NSObject, DataSource, UITableViewDataSource {
	
	typealias Cell = CellClass
	var cellOutput: CellOutput?

	var items: [Item] = []

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = Cell.dequeue(tableView: tableView, indexPath: indexPath)
		cell.configureFor(element: items[indexPath.row])
		cellOutput?.configuredCell(cell)
		return cell as! UITableViewCell
	}
}

class CollectionDataSource<Item, CellClass: Dequeable>: NSObject, DataSource, UICollectionViewDataSource {
	typealias Cell = CellClass
	var cellOutput: CellOutput?

	var items: [Item] = []

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = Cell.dequeue(collectionView: collectionView, indexPath: indexPath)
		cell.configureFor(element: items[indexPath.row])
		cellOutput?.configuredCell(cell)
		return cell as! UICollectionViewCell
	}
}


