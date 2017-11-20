//
//  MyBusinessesViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 05/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class MyBusinessesViewController : UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    private var followedBusinesses = [Business]()

    var navDelegate: NavDelegate?

    var tempLogo = UIImage(named: "tempLogo")

    
    //var label = UILabel()

    override func viewDidLoad()
    {

        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clearColor()//"#cccccc".UIColor
//        self.tableView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBusinessesInCollection:", name: "UpdatedFollowingBusinesses", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData:", name: "BusinessLogoLoaded", object: nil)
    }

    override func didReceiveMemoryWarning(){
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        User.sharedInstance.refreshFollowedBusiness()


    }
    
    func updateBusinessesInCollection (notification: NSNotification)
    {
        println("reloading data")
        loadCollectionData()
    }
    
    func loadCollectionData ()
    {
        self.followedBusinesses = User.sharedInstance.getFollowing()
        self.tableView.reloadData()
    }
    
    func reloadData (notification: NSNotification)
    {
        loadCollectionData()
    }
}

// MARK - UICollectionViewDelegate
extension MyBusinessesViewController: UITableViewDelegate
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedBusinesses.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        cell!.backgroundColor = UIColor.clearColor()
        
        let businessNum = (indexPath.section * 4) + indexPath.row
        let selectedBusiness = followedBusinesses[businessNum]
        
        navDelegate?.goToPage(Page.BusinessHome(selectedBusiness))
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell?
    {
        let cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        var oldImage = cell!.viewWithTag(1)
        if oldImage != nil {
            oldImage!.removeFromSuperview()
        }
        
        var lblTemp = cell!.viewWithTag(2)
        if lblTemp != nil {
            lblTemp!.removeFromSuperview()
        }
        
        let itemNumber = (indexPath.section * 4) + (indexPath.row)
        if followedBusinesses.count > itemNumber
        {
            let business = followedBusinesses[itemNumber]
            
            var imgCurrent = business.logoImage
            
            if imgCurrent == nil {
                imgCurrent = tempLogo
            }
            cell!.maskView?.backgroundColor = UIColor.clearColor()
            cell!.maskView?.removeFromSuperview()
            cell?.viewForBaselineLayout()?.removeFromSuperview()
            
            var imageView = UIImageView(image: imgCurrent)
            imageView.tag = 1
            imageView.frame = CGRect(x: self.view.bounds.width/2 - 40, y: 0, width: 80, height: 80)
            imageView.layer.cornerRadius = imageView.frame.size.height/2;
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            cell!.addSubview(imageView)
            
            var label = UILabel(frame: CGRectMake(self.view.bounds.width/2, 50, 200, 40))
            label.center = CGPointMake(self.view.bounds.width/2, imageView.frame.size.height + 10.0)
            label.tag = 2;
            label.textAlignment = NSTextAlignment.Center
            label.text = followedBusinesses[itemNumber].name
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "Arial", size: 5);
            label.font = label.font.fontWithSize(12)
            cell!.viewForBaselineLayout()?.addSubview(label)
            
            cell!.backgroundColor = UIColor.clearColor()
            
        }
        
        return cell
    }
    
    
    
}

