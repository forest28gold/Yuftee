//
//  User.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 14/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

class User {
        
    // http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    class var sharedInstance: User {
        struct Static {
            static var instance: User?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = User()
        }
        return Static.instance!
    }
    
    private var followedBusinesses = FollowedBusinesses()
        
    init () {

    }
    
    func refreshFollowedBusiness()
    {
        self.followedBusinesses = FollowedBusinesses();
    }

    func unFollowBusiness (businessId: String) {
        followedBusinesses.unFollowBusiness(businessId)
    }

    func followBusiness (businessId: String) {
        followedBusinesses.followBusiness(businessId)
    }
    
    func isFollowing (businessId: String, callback: (isFollowing: Bool) -> ()) {
        followedBusinesses.isFollowing(businessId, result: callback)
    }

    func getFollowing () -> [Business] {
        return followedBusinesses.businesses.values.array
    }
    
    func getBusiness (businessId: String) -> Business? {
        return followedBusinesses.businesses[businessId]
    }
    
    func getAllUpdates () -> [Update] {
        return followedBusinesses.getAllUpdates()
    }
    
}
    
