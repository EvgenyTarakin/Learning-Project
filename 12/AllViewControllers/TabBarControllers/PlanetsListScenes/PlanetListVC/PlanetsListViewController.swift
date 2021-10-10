//
//  PlanetsListViewController.swift
//  12
//
//  Created by Евгений Таракин on 05.04.2021.
//

import UIKit
import PKHUD

struct Planet {
    let name: String?
    let type: String?
    let residents: [String]
}

class PlanetsListViewController: UIViewController {

    @IBOutlet weak var planetsTableView: UITableView?
    
    let networkService: PlanetListNetworkService = NetworkService()
    var tableSource: [Planet] = []
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("727272")
        
        planetsTableView?.backgroundColor = .clear
        planetsTableView?.delegate = self
        planetsTableView?.dataSource = self
        planetsTableView?.register(UINib(nibName: "PlanetCell", bundle: nil), forCellReuseIdentifier: "PlanetCell")
        
        
        HUD.registerForKeyboardNotifications()
        HUD.allowsInteraction = false
        HUD.dimsBackground = true
        
        loadPlanets()
    }

    func loadPlanets() {
        HUD.show(.progress)
        networkService.getPlanetsList(page: page) { [weak self] (response, error) in
            HUD.hide()
            guard let results = response?.results,
                  let self = self
            else { return }
            self.tableSource.append(contentsOf: results.map({ (planetResponse) -> Planet in
                return Planet(name: planetResponse.name, type: planetResponse.type, residents: planetResponse.residents)
            }))
            self.planetsTableView?.reloadData()
            self.page += 1
        }
    }
    
    @IBAction func reloadPlanets(_ sender: Any) {
        page = 1
        tableSource = []
        loadPlanets()
    }
    
}


extension PlanetsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        58.0
    }
    
}


extension PlanetsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell") as? PlanetCell
        else { return PlanetCell() }
        
        cell.backView?.backgroundColor = UIColor("C4C4C4")
        
        cell.locationLabel?.text = tableSource[indexPath.item].name
        cell.locationLabel?.font = AppFont.medium.size(18)
        cell.locationLabel?.textColor = UIColor("565656")
        
        cell.typeLocationLabel?.text = tableSource[indexPath.item].type
        cell.typeLocationLabel?.font = AppFont.regular.size(12)
        cell.typeLocationLabel?.textColor = UIColor("565656")
        
        cell.populationLabel?.text = "Население: \(tableSource[indexPath.item].residents.count)"
        cell.populationLabel?.font = AppFont.regular.size(12)
        cell.populationLabel?.textColor = UIColor("A2A2A2")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "ResidentsOfTheLocationViewController") as? ResidentsOfTheLocationViewController,
              let name = tableSource[indexPath.item].name
        else { return }
        controller.planetName = "\(name)"
        controller.arrayResidents = tableSource[indexPath.item].residents
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == tableSource.count / 2 {
            DispatchQueue.global().async {
                self.networkService.getPlanetsList(page: self.page) { [weak self] (response, error) in
                    DispatchQueue.main.async {
                        guard let results = response?.results,
                              let self = self
                        else { return }
                        self.page += 1
                        
                        let lastIndexPathRow = self.tableSource.count
                        self.tableSource.append(contentsOf: results.map({ (planetResponse) -> Planet in
                            return Planet(name: planetResponse.name, type: planetResponse.type, residents: planetResponse.residents)
                        }))
                        var indexes: [IndexPath] = []
                        for index in lastIndexPathRow...self.tableSource.count-1 {
                            indexes.append(IndexPath(row: index, section: 0))
                        }
                        tableView.insertRows(at: indexes, with: .none)
                    }
                }
            }
        }
    }
    
}
