//
//  SettingsViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 21/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class SettingsViewController : NavPageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var editPasswordViewController = EditPasswordViewController(nibName: "EditPasswordView", bundle: NSBundle.mainBundle())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
//        self.view.backgroundColor = "#514E5D".UIColor
//        
//        var p1 = UILabel()
//        p1.frame = CGRect(x: 0, y: 0, width: 90, height: 50)
//        p1.center = self.view.center
//        p1.text = "Page 1"
//        self.view.addSubview(p1)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "aasd")

        if indexPath.row == 0 {
            cell.textLabel?.text = "Change Password"
        }
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Account"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            navigationController?.pushViewController(editPasswordViewController, animated: true)
        }

    }
    
}
