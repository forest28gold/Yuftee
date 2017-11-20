//
//  Controller.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 01/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

protocol UserDelegate {
    func logOut()
}

class AppContainer: UIViewController {
    
    // Container View Controllers
    var navigationViewController = NavigationViewController()
    var sideBar                  = SideBarViewController(nibName: "SideBarViewController", bundle: NSBundle.mainBundle())
    
    var sideBarStatus: SideBarStatus    = .Closed
    let sideBarWidth:  CGFloat          = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        registerGestures()
        // TODO: Check we're loading the businesses, messages here
        
        self.addChildViewController(sideBar)
        self.addChildViewController(navigationViewController)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpSubviews()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSubviews () {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        self.view.addSubview(sideBar.view)
        self.view.addSubview(navigationViewController.view)
        
        navigationViewController.burgerDelegate = self
        navigationViewController.userDelegate = self
        navigationViewController.view.layer.shadowOpacity = 0.8
        sideBar.view.frame = CGRect(x: 0, y: 0, width: sideBarWidth, height: self.view.bounds.height)
        //sideBar.view.frame   = CGRectMake(0, statusBarHeight, sideBarWidth, self.view.bounds.height - statusBarHeight)
        sideBar.delegate = self
        
        let topView = UIView()
        topView.backgroundColor = "B8994D".UIColor
        topView.frame = CGRect(x: 0, y: 0, width: 1000, height: statusBarHeight)
        
    }
    
    func hideNotification () {
        UIView.animateWithDuration(0.8, delay: 0, options: .CurveLinear | .AllowUserInteraction, animations: {
            self.navigationViewController.notificationView.view.alpha = 0.0
        }, completion: nil)
    }
    
    func displayNotificationForUpdate (update: Update?) {
        self.navigationViewController.notificationView.update = update
        UIView.animateWithDuration(0.8, delay: 0, options: .CurveLinear | .AllowUserInteraction, animations: {
            self.navigationViewController.notificationView.view.alpha = 1.0
        }, completion: nil)
        NSTimer.scheduledTimerWithTimeInterval(5.8, target: self, selector: "hideNotification", userInfo: nil, repeats: false)
    }
    
    func registerGestures () {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        navigationViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
        
    func handlePanGesture(recognizer:UIPanGestureRecognizer) {
        
        let limit = sideBarWidth + recognizer.view!.bounds.width/2
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Changed:
            
            let newCenterX = recognizer.view!.center.x + recognizer.translationInView(view).x
            
            if newCenterX <= self.view.bounds.width/2 {
                recognizer.view!.center.x = self.view.bounds.width/2
            } else if newCenterX <= limit {
                recognizer.view!.center.x = newCenterX
            } else {
                recognizer.view!.center.x = limit
            }
            
            recognizer.setTranslation(CGPointZero, inView: view)
            
        case .Ended:
            
            if (gestureIsDraggingFromLeftToRight && sideBarStatus == .Closed) || (!gestureIsDraggingFromLeftToRight && sideBarStatus == .Open) {
                toggleSidebar()
            } else {
                snapBack()
            }
            
        default:
            break
        }
    }

    func snapBack () {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            if self.sideBarStatus == .Open {
                self.navigationViewController.view.frame = CGRect(x: self.sideBarWidth, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            } else if self.sideBarStatus == .Closed {
                self.navigationViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            }
            
            }, completion: nil)
    }
    
}

// MARK - BurgerButtonDelegate
extension AppContainer: BurgerButtonDelegate {
    
    func toggleSidebar() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            if self.sideBarStatus == .Open {
                self.navigationViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            } else if self.sideBarStatus == .Closed {
                self.navigationViewController.view.frame = CGRect(x: self.sideBarWidth, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                
            } else {
                
            }
            
            }, completion: nil)
        
        sideBarStatus = (sideBarStatus == .Closed) ? .Open : .Closed
    }
    
}

// MARK - PageChangeDelegate
extension AppContainer: PageChangeDelegate {

    func sidebarButtonClicked(page: Page) {
        navigationViewController.switchPage(page)
        toggleSidebar()
    }
}

// MARK - UserDelegate
extension AppContainer: UserDelegate {

    func logOut() {
        
        // TODO: Clear user data on logout
        
        let install = PFInstallation.currentInstallation()
        install.removeObjectForKey("user")
        install.saveEventually()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        PFUser.logOut()
        appDelegate.goToLogin()
    }

}
