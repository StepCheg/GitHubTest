//
//  ListOfCommitsVC.swift
//  GitTest
//
//  Created by Stepan Chegrenev on 08/12/2018.
//  Copyright © 2018 Stepan Chegrenev. All rights reserved.
//

import UIKit

class ListOfCommitsVC: UITableViewController {

    var arrayOfCommits: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfCommits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommitCell

        let commitDictionary = arrayOfCommits[indexPath.row] as! [String : Any]
        
        let author = commitDictionary["author"] as! String
        let date = commitDictionary["date"] as! String
        let sha = commitDictionary["sha"] as! String
        let message = commitDictionary["message"] as! String
        
        cell.authorLsbel.text = "Author: " + author
        cell.dateLabel.text = "Date: " + date
        cell.shaLabel.text = "SHA: " + sha
        cell.messageLabel.text = "Message: " + message
        
        return cell
    }
}
