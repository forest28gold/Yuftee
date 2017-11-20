

//  NavigationViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 01/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

enum Page {
    case FollowBusinesses
    case BusinessHome(Business)
    case AllUpdates
    case Settings
    case LogOut
}

protocol NavDelegate {
    func goToPage(page: Page)
}


class NavigationViewController: UINavigationController, UIViewControllerTransitioningDelegate {

    // Page View Controllers
    var settingsViewController          = SettingsViewController(nibName: "SettingsView", bundle: NSBundle.mainBundle())
    var allUpdatesViewController        = AllUpdates(nibName: "AllUpdates", bundle: NSBundle.mainBundle())
    var businessViewController          = BusinessViewController(nibName: "BusinessView", bundle: NSBundle.mainBundle())
    var followBusinessesViewController  = FollowBusinessesViewController(nibName: "FollowBusinessesViewController", bundle: NSBundle.mainBundle())
    
    // Other View Controllers
    var notificationView = NotificationViewController(nibName: "NotificationView", bundle: NSBundle.mainBundle())
    
    // Delegates
    var burgerDelegate: BurgerButtonDelegate?
    var userDelegate: UserDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchPage(.FollowBusinesses)
        setUpPages()
        
        
        self.navigationBar.tintColor = UIColor.clearColor()
        self.navigationBar.barTintColor = UIColor.clearColor() // "#B8994D".UIColor
//        self.navigationBar.barStyle = UIBarStyle.clearColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: "E7E5E3".UIColor]

        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationBar.translucent = true
        
        notificationView.delegate = self
        notificationView.view.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPages () {
        settingsViewController.delegate = self
        settingsViewController.navDelegate = self

        allUpdatesViewController.delegate = self
        
        followBusinessesViewController.delegate = self
        followBusinessesViewController.navDelegate = self

        businessViewController.delegate = self
        businessViewController.navDelegate = self
        
        self.view.addSubview(notificationView.view)
        notificationView.view.frame = CGRectMake(0, 64, self.view.bounds.width, 64)
        notificationView.view.alpha = 0.0
    }
    
    func switchPage(page: Page)
    {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.checkReachability()
        
        if self.viewControllers as [UIViewController] == [followBusinessesViewController] {
            followBusinessesViewController.hideKeyboard()
        }
        
        switch (page)
        {
        case .FollowBusinesses:
            
            self.navigationBar.barTintColor = UIColor.clearColor()
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationBar.translucent = true

            self.setViewControllers([followBusinessesViewController], animated: false)
            
        case .BusinessHome(let biz):
            self.navigationBar.barTintColor = "#B8994D".UIColor
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: "E7E5E3".UIColor]
            
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.translucent = false

            businessViewController.business = biz
            self.setViewControllers([businessViewController], animated: false)
            
        case .AllUpdates:
            self.navigationBar.barTintColor = "#B8994D".UIColor
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: "E7E5E3".UIColor]
            
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.translucent = false
            
            self.setViewControllers([allUpdatesViewController], animated: false)
            
        case .Settings:
            self.navigationBar.barTintColor = "#B8994D".UIColor
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: "E7E5E3".UIColor]
            
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.translucent = false

            self.setViewControllers([settingsViewController], animated: false)

        case .LogOut:
            self.navigationBar.barTintColor = "#B8994D".UIColor
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: "E7E5E3".UIColor]
            
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.translucent = false
            
            self.userDelegate?.logOut()
            
        default:
            switchPage(.FollowBusinesses) // or break?
        }
    }
    
}

// MARK - BurgerButtonDelegate
extension NavigationViewController: BurgerButtonDelegate {
    func toggleSidebar () {
        // Sending up the chain to AppContainer
        self.burgerDelegate?.toggleSidebar()
    }
}

// MARK - NavDelegate
extension NavigationViewController: NavDelegate {

    func goToPage(page: Page) {
        switchPage(page)
    }

}

// MARK - NotificationDelegate
extension NavigationViewController: NotificationDelegate {
    
    func notificationTapped () {

    }
    
    func notificationTapped (update: Update) {
        notificationView.view.alpha = 0.0
        switchPage(.AllUpdates)
        allUpdatesViewController.showUpdateDetail(update)
    }
    
}
