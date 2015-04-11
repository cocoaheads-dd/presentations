//
//  Bus.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import WatchKit

class Bus {
    
    class func fetchItems(completion: (items: [WatchItem]) -> ()) {
        
        var userInfo = ["request": "allItems"]
        WKInterfaceController.openParentApplication(userInfo) { reply, error in
            
            var response: AnyObject? = reply?["response"]
            
            if let data = response as? [[String:AnyObject]] {
                
                var allItems = data.map { WatchItem.fromDictionary($0) }
                
                for item in allItems {
                    addImageForItemToCache(item)
                }
                
                completion(items: allItems)
                
                return
            }
            completion(items: [])
            
        }
        
    }
    
    class func addNewItem(item: WatchItem, completion: (Bool) -> ()) {
        
        var userInfo = ["request": "newItem", "parameter": item.convertToDictionary()]
        WKInterfaceController.openParentApplication(userInfo as [NSObject : AnyObject]) { reply, error in
            
            var response: AnyObject? = reply?["response"]
            
            if let data = response as? [String:AnyObject] {
                
                var item = WatchItem.fromDictionary(data)
                
                
                
                println(item.titel)
                
                completion(true)
                
                return
            }
            completion(false)
            
        }
        
    }
    
    
}

private func addImageForItemToCache(item: WatchItem) {
    if !WKInterfaceDevice.currentDevice().addCachedImageWithData(item.bild, name: "\(item.titel.hash)") {
        WKInterfaceDevice.currentDevice().removeAllCachedImages()
        WKInterfaceDevice.currentDevice().addCachedImageWithData(item.bild, name: "\(item.titel.hash)")
    }
}