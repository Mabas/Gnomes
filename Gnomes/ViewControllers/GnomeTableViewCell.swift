//
//  GnomeTableViewCell.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit
/**
 Se definió esta celda en caso de que se necesite mejorar para agregar más detalles, sin embargo uno de los requisitos es
 "Our heroes wil be quite busy dealing with Orcs, so apps have to be really simple"
y en la descripción dicce que los Gnomos aprecian la privacidad por eso pueden poner imagenes random, por esto se decidió mantener la lista de Gnomos solo con el nombre, y dejar todos los demás datos para el detalle
*/
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

    }

}
