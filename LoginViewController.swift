//
//  LoginViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 14/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

       // self.email.text = "james@yuftee.com";
       // self.password.text = "password";
    }
    
    var invalidLoginAlert: AlertBox?

    @IBAction func loggedIn(sender: AnyObject) {
        // Just to make sure.
        password.resignFirstResponder()
        email.resignFirstResponder()
        
        PFUser.logInWithUsernameInBackground(email.text, password: password.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                self.view.endEditing(true)
                
                appDelegate.goToApp()
                
            } else {
                self.invalidLoginAlert = AlertBox(delegate: self, title: "Invalid Login", message: "Incorrect email address or password supplied. Please try again.")
                self.invalidLoginAlert!.addButton(title: "OK", style: .Default, handler: nil)
                self.invalidLoginAlert!.show()
            }
        
        }
        
    }
    
    @IBAction func goToRegister(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.goToRegister()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

// MARK - UITextField Delegate Methods

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Ummm
        switch (textField.tag) {
            case 1:
                self.email.resignFirstResponder()
                self.password.becomeFirstResponder()
                break;
            case 2:
                self.email.resignFirstResponder()
                self.password.resignFirstResponder()
                self.loggedIn(self)
                break;
            default:
                self.email.resignFirstResponder()
                self.password.resignFirstResponder()
                textField.resignFirstResponder()
        }
        return true

    }
    
}
