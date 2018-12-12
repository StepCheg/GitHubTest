//
//  AuthVC.swift
//  GitTest
//
//  Created by Stepan Chegrenev on 08/12/2018.
//  Copyright © 2018 Stepan Chegrenev. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let reachability = Reachability()!
        if (reachability.connection != .none)
        {
            if UserDefaults.standard.string(forKey: "username") != nil {
                self.performSegue(withIdentifier: "toListOfRepositoriesSegue", sender: nil)
            }
        }
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y -= 150
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y += 150
        
    }

    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: UIButton)
    {
        
        let reachability = Reachability()!
        if (reachability.connection == .none)
        {
            self.showAlertWithOk(self, title: "Atention!", message: "Network not reachable ")
        }
        else
        {
            if let username = usernameTextField.text {
                
                if let password = passwordTextField.text {
                    
                    NetworkManager.shared.authFunc(userName: username, password: password, success: {
                        
                        self.performSegue(withIdentifier: "toListOfRepositoriesSegue", sender: nil)
                        
                    })  { (arg0) in
                        
                        let (statusCode, description) = arg0
                        
                        
                        self.showAlertWithOk(self, title: "Status code: \(statusCode)", message: description)
                    }
                    
                } else {
                    self.showAlertWithOk(self, title: "Status code", message: "HO")
                }
            } else {
                self.showAlertWithOk(self, title: "Status code", message: "HOHOHO")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func showAlertWithOk(_ owner: UIViewController, title: String, message: String) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        owner.present(alert, animated: true, completion: nil)
    }
    
}
