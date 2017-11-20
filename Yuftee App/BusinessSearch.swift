//
//  BusinessSearch.swift
//  Yuftee
//
//  Created by AppsCreationTech on 25/02/2015.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

struct BusinessesSearchResult {
    var id: String
    var name: String
}

// TODO: Possible merge these data structures. For now, trying to keep everything as neat as possible, to allow for future refactors to move away from parse.
struct BusinessToAdd {
    var id: String
    var name: String
    var logo: String
}

// TODO: Find some way of caching logos from the search page

class BusinessSearch : NSObject {
    
    class var sharedInstance: BusinessSearch {
        struct Static {
            static var instance: BusinessSearch?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = BusinessSearch()
        }
        return Static.instance!
    }
    
    override init () {
        super.init()
        self.loadAllBusinesses()
    }
    
    var storedBusinesses = [BusinessesSearchResult]()
    var loadingBusinessesQueue = Callbacks()

    // In a bigger environment, this wouldn't be needed and businesses would be download dynamically from getBusinessesFromSearch
    func loadAllBusinesses () {
        var query = PFQuery (className: "Business")
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.storedBusinesses.append(BusinessesSearchResult(
                        id: object.objectId,
                        name: object["name"]! as String
                    ))
                }
                self.loadingBusinessesQueue.resolve()
            }
            // TODO: Proper error handling on else here
        }
    }
    
    func getBusinessNamesFromSearch (searchString: String, results callback: [BusinessesSearchResult] -> ()) {
        loadingBusinessesQueue.loaded {
            let filteredBusinesses = self.storedBusinesses.filter( { (business: BusinessesSearchResult) -> Bool in
                let stringMatch = business.name.lowercaseString.rangeOfString(searchString.lowercaseString)
                return (stringMatch != nil)
            })
            callback(filteredBusinesses)
        }
    }
    
    
    // TODO: Think about moving this to a new class or refactoring alltogether to merge into existing data structures
    func fetchBusinessDetails (id: String, result callback: (BusinessToAdd) -> ()) {
        var query = PFQuery (className: "Business")
        query.getObjectInBackgroundWithId(id, block: { object, error in
            if error == nil {
                var strLogo : String
                
                if object["logo"] == nil {
                    strLogo = ""
                }else{
                    strLogo = object["logo"]!as String
                }
                
                
                callback(BusinessToAdd(id: object.objectId, name: object["name"]! as String, logo: strLogo))
            } else {
                println(error)
            }
        })
    }
    
}
