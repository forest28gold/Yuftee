//
//  NotConnectedViewController.swift
//  Yuftee
//
//  Created by AppsCreationTech on 30/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class NotConnectedViewController: UIViewController {

    var preAppControllerDelegate: PreAppControllerDelegate?
    var errorAlert: AlertBox?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tryAgainClicked(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() {
            preAppControllerDelegate?.goToApp()
        } else {
            showError()
        }
    }
    
    func showError () {
        
        errorAlert = AlertBox(delegate: self, title: "Connection Error", message: "You still aren't connected! If the problem persists, please try again later, or contact support@yuftee.com for more help.")
        errorAlert!.addButton(title: "OK", style: .Default, handler: nil)
        errorAlert!.show()

    }

}
