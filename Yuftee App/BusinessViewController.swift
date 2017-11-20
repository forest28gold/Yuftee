//
//  BusinessViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 16/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class BusinessViewController : NavPageViewController {
    
    var updateViewController = UpdateViewController(nibName: "UpdateView", bundle: NSBundle.mainBundle())

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var subHeader: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var updates = [Update]()
    var unFollowAlert: AlertBox?
    
    var business: Business? {
        didSet {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatedUpdates:", name: "UpdatedUpdates", object: business!.id)
        }
    }
    
    var refreshControl = UIRefreshControl()
    var tableViewController = UITableViewController()

    func updatedUpdates (notification: NSNotification) {
        getUpdates()
    }
    
    func updatesRefreshed () {
        self.tableView.reloadData()
        tableViewController.refreshControl!.endRefreshing()
    }
    
    func getUpdates () {
        self.updates = business!.getUpdates()
        self.updates.sort({ update1, update2 in
            return (update1.date.compare(update2.date) == .OrderedDescending)
        })
        self.updatesRefreshed()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // just to be sure
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "BusinessViewController"
    
        // http://stackoverflow.com/questions/12497940/uirefreshcontrol-without-uitableviewcontroller
        tableViewController.tableView = self.tableView
        self.refreshControl.backgroundColor = UIColor(red:0.75, green:0.36, blue:0.41, alpha:1.0)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.addTarget(self, action: "fetchUpdates", forControlEvents: .ValueChanged)
        tableViewController.refreshControl = refreshControl
    }
    
    func fetchUpdates () {
        business!.fetchUpdates {
            self.updatesRefreshed()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationItem.title = business?.name
        self.header.text = business?.name
        self.imageView =  UIInterface.circleImage(self.imageView)
        self.imageView.image = business?.logoImage
    
        self.subHeader.text = business?.info
        getUpdates()
    }
    
    @IBAction func unsubscribe(sender: AnyObject) {
        let alertMessage = "Are you sure you want to unsubscribe from \((business?.name)!)?"
        self.unFollowAlert = AlertBox(delegate: self, title: "Unsubscribing", message: alertMessage)
        self.unFollowAlert!.addButton(title: "No", style: .Cancel, handler: nil)
        self.unFollowAlert!.addButton(title: "Yes", style: .Default) {
            User.sharedInstance.unFollowBusiness(self.business!.id)
            self.navDelegate?.goToPage(Page.FollowBusinesses)
        }
        self.unFollowAlert!.show()
    }
    
    func showUpdateDetail (update: Update) {
        self.updateViewController.update = update
        navigationController?.pushViewController(updateViewController, animated: true)
    }
    
}

// MARK - UITableViewDataSource
extension BusinessViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Reuse cells
        var cell = UITableViewCell()
        let update = self.updates[indexPath.row]
        cell.textLabel?.text = update.title
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.updates.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Messages"
    }
    
}

// MARK - UITableViewDelegate
extension BusinessViewController: UITableViewDelegate
{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let update = self.updates[indexPath.row]
        showUpdateDetail(update)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
