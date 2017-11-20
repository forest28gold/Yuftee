//
//  Page2.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 02/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class AllUpdates : NavPageViewController {
    
    var updateViewController = UpdateViewController(nibName: "UpdateView", bundle: NSBundle.mainBundle())
    
    var refreshControl = UIRefreshControl()
    var tableViewController = UITableViewController()
    
    var updates: [Update] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "All Messages"

        // http://stackoverflow.com/questions/12497940/uirefreshcontrol-without-uitableviewcontroller
        tableViewController.tableView = self.tableView
        self.refreshControl.backgroundColor = UIColor(red:0.75, green:0.36, blue:0.41, alpha:1.0)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.addTarget(self, action: "getUpdates", forControlEvents: .ValueChanged)
        tableViewController.refreshControl = refreshControl
        self.getUpdates()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newUpdatesAvailable:", name: "UpdatedUpdates", object: nil)
    }
    
    
    func newUpdatesAvailable (notification: NSNotification) {
        getUpdates()
    }
    
    func updatesRefreshed () {
        self.tableView.reloadData()
        tableViewController.refreshControl!.endRefreshing()
    }
    
    func getUpdates () {
        self.updates = User.sharedInstance.getAllUpdates()
//        self.updates.sort({ update1, update2 in
//            return (update1.date.compare(update2.date) == .OrderedDescending)
//        })
        
        self.updates.sort( { update1, update2 in
            return (update1.date.compare(update2.date) == .OrderedDescending) })
        self.updatesRefreshed()
    }

    func showUpdateDetail (update: Update) {
        self.updateViewController.update = update
        navigationController?.pushViewController(updateViewController, animated: true)
    }
    
}

// MARK - UITableViewDelegate
extension AllUpdates: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let update = updates[indexPath.row]
        showUpdateDetail(update)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK - UITableViewDataSource
extension AllUpdates: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "update")
            
            let update = updates[indexPath.row]
            cell!.imageView?.image = update.getBusiness().logoImage
            cell!.textLabel?.text = update.title
            cell!.detailTextLabel!.text = TimeAgo.sinceDate(update.date, numericDates: false)
            cell!.accessoryType = .DisclosureIndicator
            cell!.imageView?.contentMode = .ScaleAspectFit
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updates.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Messages"
    }
    
}
