//
//  Application Bus.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import UIKit

class WatchKitHandler {
    
    class func addNewItem(userInfo: [String: AnyObject], completion: (response: AnyObject) -> ()) {
        
        let newWatchItem = WatchItem.fromDictionary(userInfo)
        newWatchItem.bild = UIImagePNGRepresentation(randomImage())
        var newItem = newWatchItem.saveAsItem()
        newItem.color = UIColor.random()
        managedObjectContext.insertObject(newItem)
        managedObjectContext.save(nil)
        NSNotificationCenter.defaultCenter().postNotificationName(ITEMSCHANGEDNOTIFICATION, object: nil)
        
        completion(response: newItem.mapToWatchItem().convertToDictionary())
    }
    
    class func getAllItems(completion: (response: AnyObject) -> ()) {
        
        var items = fetchItemsFromDB()
        var itemsToSend = [[String:AnyObject]]()
        for item in items {
            itemsToSend.append(item.mapToWatchItem().convertToDictionary())
        }
        
        completion(response: itemsToSend)
    }
    
    
}