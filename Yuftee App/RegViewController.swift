//
//  RegViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 19/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

class RegViewController : UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate {
    


    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    var invalidRegAlert: AlertBox?

    
    // ty http://stackoverflow.com/a/25471164
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)!.evaluateWithObject(candidate)
    }

    class func validatePasswords(password1 pass1: String, password2 pass2: String) -> (valid: Bool, error: String?) {
        
        if pass1 != pass2 {
            return(false, "Please make sure passwords match!")
        }
        
        if pass1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            return(false, "Invalid password")
        }
        
        if countElements(pass1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) < 8 {
            return(false, "Password must be at least 8 characters without spaces!")
        }
        
        return (true, nil)

    }
    
    @IBAction func regClicked(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        if !validateEmail(email.text) {
            showRegError("Invalid email address")
            return
        }
        
        if name.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            showRegError("Name required")
        }
        
        let validPasswords = RegViewController.validatePasswords(password1: password1.text, password2: password2.text)
        if !validPasswords.valid {
            showRegError(validPasswords.error!)
            return
        }
        
        email.resignFirstResponder()
        name.resignFirstResponder()
        password1.resignFirstResponder()
        password2.resignFirstResponder()
        
        var user = PFUser()
        
        user.email = email.text
        user.password = password1.text
        user.username = email.text
        user["name"] = name.text
        
        user.signUpInBackgroundWithBlock({ succeeded, error in
            if error == nil {
                appDelegate.goToApp()
            } else {
                self.showRegError("Email address is already in use. Please try with a different email.")
            }
        })
        
    }
    
    func goToLogin() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.goToLogin()
    }
    
    
    @IBAction func back(sender: AnyObject) {
        self.goToLogin()
    }
    
    func showRegError (error: String) {
        invalidRegAlert = AlertBox(delegate: self, title: "Registration Error", message: error)
        invalidRegAlert!.addButton(title: "OK", style: .Default, handler: nil)
        invalidRegAlert!.show()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch (textField.tag) {
        case 1:
            self.email.resignFirstResponder()
            self.name.becomeFirstResponder()
            break;
        case 2:
            self.name.resignFirstResponder()
            self.password1.becomeFirstResponder()
            break;
        case 3:
            self.password1.resignFirstResponder()
            self.password2.becomeFirstResponder()
            break;
        case 4:
            self.password2.resignFirstResponder()
            self.regClicked(self)
            break;
        default:
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    
    
    
}
