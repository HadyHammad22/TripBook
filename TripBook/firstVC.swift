//
//  firstVC.swift
//  TripBook
//
//  Created by HadyHammad on 2/8/20.
//  Copyright © 2020 HadyHammad. All rights reserved.
//

import UIKit
import CoreData

class firstVC: UIViewController {

    // MARK :- Outlets
    @IBOutlet weak var locationTV: UITableView!
    
    // MARK :- Properities
    var locationArray:[Location]?
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
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
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
}

extension firstVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.locationArray?[indexPath.row].title
        return cell
    }
}
