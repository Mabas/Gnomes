//
//  GnomeTableViewCell.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit

class GnomeTableViewCell: UITableViewCell, Dequeable {

	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func configureFor<T>(element: T) {
		if let gnome = element as? GnomeModel {
			textLabel?.text = gnome.name
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
