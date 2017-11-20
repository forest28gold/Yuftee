//
//  AppDelegate.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 01/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var preAppView  = PreAppViewController() // Used for login/reg
    var mainView    = UIViewController()     // Used for controlling the main app
    
    var appContainer = AppContainer(nibName: "AppContainer", bundle: nil)

    func regPushNotifications (application: UIApplication) {
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge  | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)
        }
    
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveEventually()
        PFPush.storeDeviceToken(deviceToken)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PushNotificationsRegistered")
    }
    
    func handleUpdateNotification(update: Update, applicationState: UIApplicationState) {
        if applicationState == .Inactive {
            self.appContainer.navigationViewController.notificationTapped(update)
        } else if applicationState == .Active {
            self.appContainer.displayNotificationForUpdate(update)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

        // TODO: Send this out to a new class to handle this logic
        // Saving here, because it might've changed by the time we've loaded the update?
        let applicationState = application.applicationState
        
        if userInfo["update"] != nil && userInfo["author"] != nil {
            if let business = User.sharedInstance.getBusiness(userInfo["author"]! as String) {
                business.fetchUpdates {
                    if let update = business.getUpdateWithId(userInfo["update"]! as String) {
                        self.handleUpdateNotification(update, applicationState: applicationState)
                    }
                }
            }
        }
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error.localizedDescription)
        println("could not register: \(error)")
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Parse.setApplicationId("lJfSOBqE31Ov3ch9GRfTg4IRkIhok8PLY7bjGCtr", clientKey: "opog1DrQwlpPnUVrwQsJLZxRVl43CucaRH8nheD8")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("PushNotificationsRegistered") {
            regPushNotifications(application)
        }
        
        mainView.addChildViewController(appContainer)


        appContainer.view.frame = UIScreen.mainScreen().bounds
        mainView.view.frame     = UIScreen.mainScreen().bounds
        preAppView.view.frame   = UIScreen.mainScreen().bounds
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()

        startApp()
        
        return true
    }
    
    func startApp () {
        if PFUser.currentUser() != nil {
            goToApp()
        } else {
            goToLogin()
        }
    }
    
    func goToApp () {
        // Sync up the user with this installation
        
        // TODO: Make this so that it doesn't run if the
        // app is just auto logging in from a saved login
        
        // Sync up the install's user with the current user
        let install = PFInstallation.currentInstallation()
        install["user"] = PFUser.currentUser()
        install.saveEventually()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "LoadData", object: nil))
        
        // TODO: Find a good place for this data init stuff
        BusinessSearch.sharedInstance
        
        // Replace view with mainView
        for view in self.mainView.view.subviews {
            view.removeFromSuperview()
        }
        self.mainView.view.addSubview(self.appContainer.view)
        self.window?.rootViewController = self.mainView
        
    }
    
    func goToLogin () {
        preAppView.goToView(.Login)
        self.window?.rootViewController = preAppView
    }

    func goToRegister () {
        preAppView.goToView(.Register)
        self.window?.rootViewController = preAppView
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkReachability()
        
        if Reachability.isConnectedToNetwork() {
            let currentInstallation = PFInstallation.currentInstallation()
            if currentInstallation.badge != 0 {
                currentInstallation.badge = 0
                currentInstallation.saveEventually()
            }
            
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "LoadData", object: nil))
        }
    }

    func checkReachability () {
    // TODO: Check this more often throughout app
        if !Reachability.isConnectedToNetwork() {
            self.window?.rootViewController = preAppView
            preAppView.view.addSubview(preAppView.notConnected.view)
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Yuftee.Yuftee_App" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Yuftee_App", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Yuftee_App.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

