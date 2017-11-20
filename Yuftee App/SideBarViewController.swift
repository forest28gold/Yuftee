//
//  SideBarViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 01/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

enum SideBarStatus: Int {
    case Closed
    case Open
    case Moving
}

protocol PageChangeDelegate {
    func sidebarButtonClicked(page: Page)
}

class SideBarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var person: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate: PageChangeDelegate?
    
    let pages: [[[String: Any]]] = [
        [
            [
                "title" : "My Businesses",
                "image": "business",
                "link": Page.FollowBusinesses,
                "hideLine": false
            ],
            [
                "title" : "Messages",
                "image": "updates",
                "link": Page.AllUpdates,
                "hideLine": true
            ]
        ],
        [
            [
                "title" : "Settings",
                "image": "settings",
                "link": Page.Settings,
                "hideLine": false
            ],
            [
                "title" : "Log Out",
                "image": "logout",
                "link": Page.LogOut,
                "hideLine": true
            ]
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestures()
        self.tableView.backgroundColor = "FFFFFF".UIColor(0)
        tableView.scrollEnabled = false
        person.image = person.image?.imageWithRenderingMode(.AlwaysTemplate)
        person.tintColor = "72543D".UIColor
        tableView.separatorStyle = .None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_loadData:", name: "LoadData", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Dirty hack
        super.viewDidAppear(animated)
        let currentUser = PFUser.currentUser()
        nameLabel.text = currentUser?["name"]! as String?
    }
    
    func _loadData (notification: NSNotification) {
        var currentUser = PFUser.currentUser()
        nameLabel.text = currentUser?["name"]! as String?
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerGestures () {
        let tap = UITapGestureRecognizer(target: self, action: "tappedOnTable:")
        self.tableView.addGestureRecognizer(tap)
    }
    
    func tappedOnTable(recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.locationInView(self.tableView)
        let indexPath   = self.tableView.indexPathForRowAtPoint(tapLocation)
        
        if indexPath == nil {
            recognizer.cancelsTouchesInView = false
            
        } else {
            
//            if indexPath!.row < pages.count {
                handleNavigation(indexPath!)
//            }
            
        }
    }
    
    func handleNavigation (indexPath: NSIndexPath) {
        let subMenu = pages[indexPath.section]
        let button = subMenu[indexPath.row]
        let page = button["link"] as? Page
        
        self.delegate?.sidebarButtonClicked(page!)
        
    }

}

// MARK - UITableViewDataSource
extension SideBarViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.pages.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let subMenu = pages[indexPath.section]
        let page = subMenu[indexPath.row]
        var cell = SideBarTableViewCell()
        cell.hideLine = true
        cell.textLabel?.text = page["title"] as? String
        cell.backgroundColor = "ffffff".UIColor(0)
        cell.selectionStyle = .None
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.textColor = "8f735c".UIColor
    
        let hideLine = page["hideLine"] as? Bool
        cell.hideLine = hideLine!
        
        let imageName = page["image"] as? String
        cell.leftImage.image = UIImage(named: imageName!)
        cell.leftImage.image = cell.leftImage.image!.imageWithRenderingMode(.AlwaysTemplate)
        cell.leftImage.tintColor = "71533d".UIColor
        
        return cell
    }
    
}

// MARK - UITableViewDelegate
extension SideBarViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.backgroundColor = "72543d".UIColor(0.4)
        var label = UILabel(frame: CGRectMake(12, 2, self.view.bounds.width - 16, 30))
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = "ffffff".UIColor
        
        switch section {
        case 0:
            label.text = "BUSINESSES"
        case 1:
            label.text = "ACCOUNT"
        default:
            label.text = ""
        }
        
        view.addSubview(label)
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
}
