//
//  BusinessMessages.swift
//  Yuftee
//
//  Created by AppsCreationTech on 26/02/2015.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

class BusinessMessages {
 
    var messages = [String: Update]()
    var businessId: String
    
    init (businessId: String) {
        self.businessId = businessId
    }
    
    func addLoadedMessage (update: Update) {
        if messages.count == 0 || messages[update.id] == nil {
            messages[update.id] = update
        }
    }
    
    func searchForNewMessages (#callback: (() -> ())?) {
        let businessObj = PFObject(withoutDataWithClassName: "Business", objectId: businessId)
        var query = PFQuery(className: "Update")
        query.whereKey("author", equalTo: businessObj)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    let update = Update.fromPF(object, author: self.businessId)
                    self.addLoadedMessage(update)
                }
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdatedUpdates", object: self.businessId))
            }
            if callback != nil { callback!() }
        })

    }
    
}
