//
//  Callbacks.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 18/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

class Callbacks {
    
    var resolvesNeeded: Int

    init () {
        self.resolvesNeeded = 1
    }
    
    init (numberOfResolves: Int) {
        self.resolvesNeeded = numberOfResolves
        if numberOfResolves <= 0 {
            isLoaded = true
        }
    }
    
    var callbackQueue: [() -> ()] = []
    
    var isLoaded = false
    
    func loaded (callback: () -> ()) {
        if isLoaded {
            callback()
        } else {
            callbackQueue.append(callback)
        }
    }
    
    func resolve () {
        resolvesNeeded = resolvesNeeded - 1
        if resolvesNeeded <= 0 {
            isLoaded = true
            for callback in callbackQueue {
                self.loaded(callback)
            }
        }
    }
    
}
