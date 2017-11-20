//
//  Business.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 10/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

class Business
{
    
    class func PF2Biz (parseObj: AnyObject) -> Business
    {
        let newBusiness = Business(
            id: parseObj.objectId,
            name: parseObj["name"]! as String,
            logo: parseObj["logo"]! as? String,
            info: parseObj["info"]! as? String

        )
        return newBusiness
    }
    
    var businessMessages: BusinessMessages
    
    var updates: [String: Update] = [String: Update]()
        {
        didSet {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "UpdateUpdates", object: self.id))
        }
    }
    
    func toPF () -> PFObject {
        let obj = PFObject(withoutDataWithClassName: "Business", objectId: self.id)
        return obj
    }
    
    var name: String
    var id: String
    var info: String?
    var logoURL: String?
    var logoImage: UIImage? // TODO: Add clear images function on memory warning
    
    
    init (id: String, name: String, logo: String?, info: String?) {
        self.id = id
        self.name = name
        self.logoURL = logo
        self.info = info
        self.businessMessages = BusinessMessages(businessId: id)
    }

    func getUpdates () -> [Update] {
        return businessMessages.messages.values.array
    }
    
    func fetchUpdates(callback: (() -> ())?) {
        businessMessages.searchForNewMessages {
            if callback != nil {
                callback!()
            }
        }
    }
    
    func loadLogo ()
    {
        if self.logoImage == nil && self.logoURL != nil
        {
            LogoDownloader.getImage(self.logoURL!, handler: { image in
                self.logoImage = image
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "BusinessLogoLoaded", object: nil))
            })
        }
    }
    
    func getUpdateWithId (updateId: String) -> Update? {
        return businessMessages.messages[updateId]
    }
    
}
