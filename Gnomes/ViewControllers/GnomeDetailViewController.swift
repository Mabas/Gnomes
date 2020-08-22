//
//  GnomeDetailViewController.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit

class GnomeDetailViewController: UIViewController {

	var coordinator: GnomeCoordinator?
	
	var gnome: GnomeModel!
	
	var professionsDataSource = TableDataSource<String, TextTableViewCell>()
	var friendsDataSource = TableDataSource<String, TextTableViewCell>()
	
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var fisiologicDetails: UILabel!
	
	@IBOutlet weak var professionsTableView: UITableView!
	@IBOutlet weak var friendsTableView: UITableView!
	
	@IBOutlet weak var proffesionsHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var friendsHeightConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		title = gnome.name
		
		if let url = URL(string: gnome.thumbnail) {
			ImageManager.shared.downloadImage(url: url) { [weak self] (image, error, _) in
				DispatchQueue.main.async {
					if let image = image {
						self?.imageView.image = image
					}
				}
			}
		}
		
		view.backgroundColor = gnome.hairColor.uiColor
		
		fisiologicDetails.text = "w: \(String(format: "%.2f", gnome.weight)), h: \(String(format: "%.2f", gnome.height))"
		
		professionsTableView.dataSource = professionsDataSource
		professionsDataSource.items = gnome.professions.map{ $0.rawValue }
		proffesionsHeightConstraint.constant = CGFloat(gnome.professions.count * 30)
		
		friendsTableView.dataSource = friendsDataSource
		friendsDataSource.items = gnome.friends
		friendsHeightConstraint.constant = CGFloat(gnome.friends.count * 30)
		//let emptySpace = view.frame.height
		//if friendsHeightConstraint.constant <  {
			//<#code#>
		//}

    }
    

}

extension GnomeDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if tableView == professionsTableView {
			let prof = Professions(rawValue: professionsDataSource.items[indexPath.row])
			coordinator?.showProfession(prof!)
		}
		else if tableView == friendsTableView {
			coordinator?.showFriend(friendsDataSource.items[indexPath.row])
		}
	}
}


class TextTableViewCell: UITableViewCell, Dequeable {
	func configureFor<T>(element: T) {
		if let text = element as? String {
			textLabel?.text = text
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}
