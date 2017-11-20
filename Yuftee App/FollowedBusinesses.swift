//
//  FollowedBusinesses.swift
//  Yuftee
//
//  Created by AppsCreationTech on 25/02/2015.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

class FollowedBusinesses
{
    
    var businesses = [String:Business]()
    var businessesLoaded = Callbacks()

    init ()
    {
        loadInitialBusinesses()
        businessesLoaded.loaded
            {
            self.loadAllLogos(progress: nil)
            MultiMessagesLoader.fetchAll()
        }
    }
    
    func loadInitialBusinesses ()
    {
        var user = PFUser.currentUser()
        var relation = user.relationForKey("follows")
        relation.query().findObjectsInBackgroundWithBlock
            {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for object in objects {
                    self.businesses[object.objectId] = Business.PF2Biz(object)
                    // TODO: Decide if we want to really keep this here? Or give this a different name idk
                    
                }
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedFollowingBusinesses", object: nil))
                
                self.businessesLoaded.resolve()
                
            }
        }
    }

    func followBusiness (businessId: String)
    {
        let pfBusiness = PFObject(withoutDataWithClassName:"Business", objectId: businessId)
        var user = PFUser.currentUser()
        var relation = user.relationForKey("follows")
        relation.addObject(pfBusiness)
        user.saveInBackgroundWithBlock(nil)
        pfBusiness.fetchInBackgroundWithBlock({ object, error in
            if error == nil {
                self.businesses[businessId] = Business.PF2Biz(object)
                // TODO: Move this completion stuff to user class
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedFollowingBusinesses", object: nil))
                self.businesses[businessId]!.loadLogo()
                self.businesses[businessId]!.fetchUpdates {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedUpdates", object: businessId))
                }
            }
        })
    }

    func unFollowBusiness (businessId: String)
    {
        let pfBusiness = PFObject(withoutDataWithClassName:"Business", objectId: businessId)
        var user = PFUser.currentUser()
        var relation = user.relationForKey("follows")
        relation.removeObject(pfBusiness)
        user.saveInBackgroundWithBlock(nil)
        self.businesses[businessId] = nil
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedFollowingBusinesses", object: nil))
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedUpdates", object: nil))
    }

    func isFollowing(businessId: String, result callback: (isFollowing: Bool) -> ()) {
        businessesLoaded.loaded {
            if let business = self.businesses[businessId] {
                callback(isFollowing: true)
            } else {
                callback(isFollowing: false)
            }
        }
    }
    
    func loadAllLogos (progress callback: (() -> ())?) {
        for business in businesses.values.array {
            business.loadLogo()
        }
    }
    
    func getAllUpdates () -> [Update] {
        return User.sharedInstance.getFollowing().reduce([]) { $0  + $1.getUpdates() }
    }
    
}
