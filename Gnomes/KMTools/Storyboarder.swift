//  KMTools
//  based on Paul Hudson tutorial
//  Created by mabas on 13/07/20.
//  Copyright © 2020 Kmabas. All rights reserved.
//
import UIKit

protocol Storyboarded {
	static func instantiate(fromSB sbName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
	static func instantiate(fromSB sbName: String = "Main") -> Self {
		let fullName = NSStringFromClass(self)
		let className = fullName.components(separatedBy: ".")[1]
		let storyboard = UIStoryboard(name: sbName, bundle: Bundle.main)
		return storyboard.instantiateViewController(withIdentifier: className) as! Self
	}
}

extension UIViewController: Storyboarded {}

protocol Dequeable {
	static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> Self
	static func dequeue(tableView: UITableView, indexPath: IndexPath) -> Self
	func configureFor<T>(element: T)
}

extension Dequeable {
	static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> Self {
		return UICollectionViewCell() as! Self
	}
	static func dequeue(tableView: UITableView, indexPath: IndexPath) -> Self {
		return UITableViewCell() as! Self
	}
}

extension Dequeable where Self: UICollectionViewCell {
	static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> Self {
		let fullName = NSStringFromClass(self)
		let className = fullName.components(separatedBy: ".")[1]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: className, for: indexPath)
		return cell as! Self
	}
}

extension Dequeable where Self: UITableViewCell {
	static func dequeue(tableView: UITableView, indexPath: IndexPath) -> Self {
		let fullName = NSStringFromClass(self)
		let className = fullName.components(separatedBy: ".")[1]
		let cell = tableView.dequeueReusableCell(withIdentifier: className, for: indexPath)
		return cell as! Self
	}
}
