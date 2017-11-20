//
//  Update.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 14/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

class Update {
    
    class func fromPF (parseObj: AnyObject, author businessId: String) -> Update {
        var newUpdate = Update(
            title: parseObj["title"]! as String,
            body: parseObj["body"]! as String,
            id: parseObj.objectId,
            author: businessId,
            date: parseObj.createdAt
        )
        
        if parseObj["eventTime"] != nil {
            newUpdate.eventTime = parseObj["eventTime"]! as? NSDate
        }
        
        return newUpdate
    }
    
    var title: String
    var body: String
    var id: String
    var author: String // businessId
    var date: NSDate
    var eventTime: NSDate?
    
    init (title: String, body: String, id: String, author: String, date: NSDate) {
        self.title = title
        self.body = body
        self.id = id
        self.author = author
        self.date = date
    }
    
    func isEvent () -> Bool {
        if self.eventTime == nil {
            return false
        } else {
            return true
        }
    }
    
    func getBusiness () -> Business {
        return User.sharedInstance.getBusiness(author)!
    }
    
}
