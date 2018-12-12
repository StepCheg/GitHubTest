//
//  ListOfRepositoriesVC.swift
//  GitTest
//
//  Created by Stepan Chegrenev on 08/12/2018.
//  Copyright © 2018 Stepan Chegrenev. All rights reserved.
//

import UIKit

class ListOfRepositoriesVC: UITableViewController {

    private var reposytoriesNamesArray: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reposytoriesNamesArray = []
        
        let username = UserDefaults.standard.string(forKey: "username")
        
        NetworkManager.shared.getListOfRepositories(userName: username!, success: { (arr) in
            
            self.reposytoriesNamesArray = arr
            
                self.tableView.reloadData()
            
        }) { (arg0) in
            
            let (statusCode, description) = arg0
            
            self.showAlertWithOk(self, title: "Status code: \(statusCode)", message: description)
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reposytoriesNamesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = reposytoriesNamesArray[indexPath.row]
        
        // Configure the cell...

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reachability = Reachability()!
        if (reachability.connection == .none)
        {
            self.showAlertWithOk(self, title: "Atention!", message: "Network not reachable ")
        }
        else
        {
            self.performSegue(withIdentifier: "toRepositoryInfoSegue", sender: reposytoriesNamesArray[indexPath.row])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toRepositoryInfoSegue")
        {
            let destVC = segue.destination as! InfoAboutRepositoryVC
            let senderObject = sender as! String
//
            destVC.repositoryName = senderObject
        }
    }
    
    func showAlertWithOk(_ owner: UIViewController, title: String, message: String) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        owner.present(alert, animated: true, completion: nil)
    }
    
}
