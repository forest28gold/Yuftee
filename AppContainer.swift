//
//  Controller.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 01/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit


class AppContainer: UIViewController {
    
    var sideBar                     = SideBarViewController(nibName: "SideBarViewController", bundle: NSBundle.mainBundle())
    var navigationViewController    = NavigationViewController(nibName: "NavigationViewController", bundle: NSBundle.mainBundle())
    
    var sideBarStatus: SideBarStatus    = .Closed
    let sideBarWidth:  CGFloat          = 110
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestures()
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
        self.view.addSubview(sideBar.view)
        self.view.addSubview(navigationViewController.view)

        navigationViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.bounds.height)
        navigationViewController.view.layer.shadowOpacity = 0.8
        sideBar.view.frame = CGRect(x: 0, y: 0, width: sideBarWidth, height: self.view.bounds.height)
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
