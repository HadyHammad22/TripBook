//
//  firstVC.swift
//  TripBook
//
//  Created by HadyHammad on 2/8/20.
//  Copyright © 2020 HadyHammad. All rights reserved.
//

import UIKit

class firstVC: UIViewController {

    // MARK :- Outlets
    @IBOutlet weak var locationTV: UITableView!
    
    // MARK :- Properities
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK :- Actions
    @IBAction func addButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
}

extension firstVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Ortega Park"
        return cell
    }
}
