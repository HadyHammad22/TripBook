//
//  SavedLocationsVC.swift
//  TripBook
//
//  Created by Hady Hammad on 2/28/20.
//  Copyright © 2020 HadyHammad. All rights reserved.
//

import UIKit
import CoreData

class SavedLocationsVC: UIViewController {
    
    // MARK :- Outlets
    @IBOutlet weak var locationTV: UITableView!
    
    // MARK :- Properities
    var locationArray : [Location]?
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "newLocationCreated"), object: nil)
    }
    
    @objc func fetchData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchedData:NSFetchRequest<Location> = Location.fetchRequest()
        do{
            locationArray = try context.fetch(fetchedData)
            locationTV.reloadData()
        }catch{
            print("can't load the data from database")
        }
    }
    
    // MARK :- Actions
    @IBAction func addButtonClicked(_ sender: Any) {
        navigationController?.pushViewController(MapVC.instance(), animated: true)
    }
    
}

extension SavedLocationsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.locationArray?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVC = MapVC.instance()
        mapVC.transmitLocation = locationArray?[indexPath.row]
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let title = self.locationArray?[indexPath.row].title else {return}
        if editingStyle == .delete{
            let alert = UIAlertController(title: "Do you want to delete \"\(title)\" from the list of location?", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                if let deletedLocation = self.locationArray?[indexPath.row]{
                    context.delete(deletedLocation)
                    appDelegate.saveContext()
                    self.fetchData()
                }
            })
            alert.addAction(okAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
