//
//  InfoAboutRepositoryVC.swift
//  GitTest
//
//  Created by Stepan Chegrenev on 08/12/2018.
//  Copyright © 2018 Stepan Chegrenev. All rights reserved.
//

import UIKit

class InfoAboutRepositoryVC: UIViewController {

//    var dictionary: [String: Any]?
    var repositoryName: String?
    
    @IBOutlet weak var openCommitsVCButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserDefaults.standard.string(forKey: "username")
        
        NetworkManager.shared.getInfoAboutRepository(userName: username!, repository: repositoryName!, success: { (dictionary) in
            
            
            self.usernameLabel.text = dictionary["login"] as? String
            
            self.titleLabel.text = dictionary["name"] as? String
            
            if let description = dictionary["description"] {
                self.descriptionLabel.text = description as? String
            } else {
                self.descriptionLabel.text = "No description"
            }
            
            self.forksLabel.text = "Forks: \(dictionary["forks_count"] as! Int)"
            self.watchersLabel.text = "Watchers: \(dictionary["watchers_count"] as! Int)"
            
            NetworkManager.shared.getAvatar(avatarURL: dictionary["avatar_url"] as! String, success: { (image) in
                self.avatarImageView.image = image
            })
            
        }) { (arg0) in
            
            let (statusCode, description) = arg0
            
            self.showAlertWithOk(self, title: "Status code: \(statusCode)", message: description)
            
        }
    }
    
    @IBAction func openCommitsVC(_ sender: UIButton)
    {
        let reachability = Reachability()!
        if (reachability.connection == .none)
        {
            self.showAlertWithOk(self, title: "Atention!", message: "Network not reachable ")
        }
        else
        {
            openCommitsVCButton.isUserInteractionEnabled = false
            
            let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                
                timer.invalidate()
                self.openCommitsVCButton.isUserInteractionEnabled = true
            }
            
            let username = UserDefaults.standard.string(forKey: "username")
            
            NetworkManager.shared.getListOfCommits(userName: username!, repositoryName: titleLabel.text!, success: { (array) in
                //            print(array)
                self.performSegue(withIdentifier: "toCommitsVCSegue", sender: array)
                
            }) { (arg0) in
                
                let (statusCode, description) = arg0
                
                
                self.showAlertWithOk(self, title: "Status code: \(statusCode)", message: description)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "toCommitsVCSegue")
        {
            let destVC = segue.destination as! ListOfCommitsVC
            let senderObject = sender as! [[String : Any]]
            destVC.arrayOfCommits = senderObject
//            destVC = senderObject
            
            
        }
    }
 
    func showAlertWithOk(_ owner: UIViewController, title: String, message: String) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        owner.present(alert, animated: true, completion: nil)
    }
    
}
