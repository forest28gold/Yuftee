//
//  InitialMessagesLoader.swift
//  Yuftee
//
//  Created by AppsCreationTech on 26/02/2015.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

class MultiMessagesLoader {
    
    class func fetchAll () {
        
        let following = User.sharedInstance.getFollowing().map {(biz: Business) -> PFObject in
            return biz.toPF()
        }
        
        var query = PFQuery(className: "Update")
        query.whereKey("author", containedIn: following)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    let author = object["author"] as PFObject
                    let update = Update.fromPF(object, author: author.objectId)
                    let business = User.sharedInstance.getBusiness(author.objectId)
                    business?.businessMessages.addLoadedMessage(update)
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedUpdates", object: author.objectId as String))
                }
            }
        })
        
    }

}
