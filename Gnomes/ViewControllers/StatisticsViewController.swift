//
//  ProfessionsViewController.swift
//  Gnomes
//
//  Created by mabas on 22/08/20.
//  Copyright © 2020 kmabas. All rights reserved.
//

import UIKit
typealias DictTuple = (key: String, value: Int)

struct Statistics {
	var professions: [DictTuple]
	
	var popularGnomes: [DictTuple]
	
	var hermitGnomes: [String]

	var workaholics: [GnomeModel]
	
	var laziests: [GnomeModel]
	
	init() {
		professions = DBEntitiesApi().getProfessions().map{ (tuple) -> (key: String, value: Int) in
			return tuple
		}.sorted {
			$0.value > $1.value
		}
		let mentions = DBEntitiesApi().getMentions()
		
		popularGnomes = mentions.sorted {
			$0.value > $1.value
		}.prefix(5).map{ (tuple) -> (key: String, value: Int) in
			return tuple
		}
		

		hermitGnomes = mentions.filter {
			return $0.value == 0
			}.prefix(5).map {
			return "\($0.key)"
		}
		
		let gnomes = DBEntitiesApi().getGnomes()
		
		workaholics = Array(gnomes.sorted {
			$0.professions.count > $1.professions.count
		}.prefix(5))
		
		laziests = Array(gnomes.sorted {
			$0.professions.count < $1.professions.count
		}.prefix(5))
	}
	
	func sectionIsValid(section: Int) -> Bool {
		return section >= 0 && section < 5
	}
	
	subscript(section: Int) -> (title: String, values: Any, rows: Int) {
		assert(sectionIsValid(section: section), "Index out of range")
		switch section {
			case 0:
				return (title: "Professions", values: professions, rows: professions.count)
			case 1:
				return (title: "Loved", values: popularGnomes, rows: popularGnomes.count)
			case 2:
				return (title: "Hated", values: hermitGnomes, rows: hermitGnomes.count)
			case 3:
				return (title: "Workaholics", values: workaholics, rows: workaholics.count)
			case 4:
				return (title: "Laziests", values: laziests, rows: laziests.count)
			default:
				return (title: "", values: "", rows: 0)
		}
	}
	
	subscript(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell? {
		assert(sectionIsValid(section: indexPath.section), "Index out of range")
		switch indexPath.section {
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath)
				let prof = professions[indexPath.row]
				cell.textLabel?.text = prof.key
				cell.detailTextLabel?.text = "\(prof.value)"
				return cell
			
			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
				let pop = popularGnomes[indexPath.row]
				cell.textLabel?.text = pop.key
				cell.detailTextLabel?.text = "\(pop.value) gnomes consider \(pop.key) as a friend"
				return cell
			
			case 2:
				let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath)
				let hermit = hermitGnomes[indexPath.row]
				cell.textLabel?.text = hermit
				cell.detailTextLabel?.text = ""
				return cell
			
			case 3:
				let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
				let gnome = workaholics[indexPath.row]
				cell.textLabel?.text = gnome.name
				cell.detailTextLabel?.text = "Has \(gnome.professions.count) professions"
				return cell
			
			case 4:
				let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
				let gnome = laziests[indexPath.row]
				cell.textLabel?.text = gnome.name
				cell.detailTextLabel?.text = "Has \(gnome.professions.count) professions"
				return cell
			
			default:
				return nil
		}
	}
	
	var sections: Int {
		5
	}
}
class StatisticsViewController: UIViewController {
	var statistics = Statistics()
	
	var coordinator: GnomeCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension StatisticsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return statistics.sections
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return statistics[section].rows
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return statistics[indexPath, tableView] ?? UITableViewCell()
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return statistics[section].title
	}
}

extension StatisticsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		switch indexPath.section {
			case 0:
				if let values = statistics[indexPath.section].values as? [DictTuple],
					let profession = Professions(rawValue: values[indexPath.row].key) {
					coordinator?.showProfession(profession)
				}
			case 1:
				let values = statistics[indexPath.section].values as? [DictTuple]
				if let popular = values?[indexPath.row] {
					coordinator?.showFriend(popular.key)
			}
			case 2:
				let values = statistics[indexPath.section].values as? [String]
				if let hermit = values?[indexPath.row] {
					coordinator?.showFriend(hermit)
			}
			case 3:
				let values = statistics[indexPath.section].values as? [GnomeModel]
				if let gnome = values?[indexPath.row] {
					coordinator?.showGnome(gnome)
				}
			case 4:
				let values = statistics[indexPath.section].values as? [GnomeModel]
				if let gnome = values?[indexPath.row] {
					coordinator?.showGnome(gnome)
				}
			default:
				print("Not valid section")
		}
	}
}
