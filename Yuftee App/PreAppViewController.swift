//
//  PreAppViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 19/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//


import UIKit

protocol PreAppControllerDelegate {
    func goToApp()
}

enum View {
    case Login
    case Register
}

class PreAppViewController : UIViewController {
    
    // Sub View Controllers
    var notConnected = NotConnectedViewController(nibName: "NotConnectedViewController", bundle: nil)
    var register     = RegViewController(nibName: "RegisterView", bundle: nil)
    var logIn        = LoginViewController(nibName: "LoginView", bundle: nil)

    var currentSubview: UIView?
    
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        // Configure Sub View Controllers
        self.addChildViewController(notConnected)
        self.addChildViewController(register)
        self.addChildViewController(logIn)
        
        notConnected.view.frame = UIScreen.mainScreen().bounds
        register.view.frame     = UIScreen.mainScreen().bounds
        logIn.view.frame        = UIScreen.mainScreen().bounds
        
        // Configure Sub View Controller Delegates
        notConnected.preAppControllerDelegate = self
        
    }
    
    func goToView (view: View) {
        switch view {
        case .Login:
            self.view.addSubview(logIn.view)
            currentSubview = logIn.view
            self.transitionFromViewController(register, toViewController: logIn, duration: 0.7, options: UIViewAnimationOptions.TransitionCurlUp, animations: nil, completion: nil)
        case .Register:
            self.view.addSubview(register.view)
            currentSubview = register.view
            self.transitionFromViewController(logIn, toViewController: register, duration: 0.7, options: UIViewAnimationOptions.TransitionCurlDown, animations: nil, completion: nil)
        default:
            currentSubview?.removeFromSuperview()
        }
    }
    
    func dismissKeyboard () {
        self.view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

// MARK - PreAppControllerDelegate
extension PreAppViewController: PreAppControllerDelegate {
    
    func goToApp () {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate        
        appDelegate.startApp()
    }
    
}
