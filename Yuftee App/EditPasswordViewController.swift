//
//  EditPasswordViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 21/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class EditPasswordViewController : NavPageViewController {
    
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    var passwordChanged: AlertBox?
    
    override func viewDidLoad() {
        showBurger = false
        super.viewDidLoad()
        self.navigationItem.title = "Edit Password"
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
    
        let validPasswords = RegViewController.validatePasswords(password1: password1.text, password2: password2.text)
        if !validPasswords.valid {
            let alertMessage = validPasswords.error!
            self.passwordChanged = AlertBox(delegate: self, title: "Error", message: alertMessage)
            self.passwordChanged!.addButton(title: "OK", style: .Default, handler: nil)
            self.passwordChanged!.show()
        } else {
            changePassword(password1.text)
        }
        
    }
    
    func goToSettings () {
        self.navigationController?.popViewControllerAnimated(true)
        self.password1.text = ""
        self.password2.text = ""
    }
    
    func changePassword(password: String) {
        var currentUser = PFUser.currentUser()
        currentUser.password = password
        currentUser.saveInBackgroundWithBlock({ success, error in
            self.passwordChanged = AlertBox(delegate: self, title: "Password Changed", message: "Your password has been changed.")
            self.passwordChanged!.addButton(title: "OK", style: .Default) {
                self.goToSettings()
            }
            self.passwordChanged!.show()
        })
    }

}
