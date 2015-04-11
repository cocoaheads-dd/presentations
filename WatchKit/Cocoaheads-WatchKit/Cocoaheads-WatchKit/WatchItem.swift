//
//  WatchItem.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import UIKit

class WatchItem: NSObject {
    
    var titel: String
    var bild: NSData
    var datum: NSDate
    var farbe: NSData
    
    override init() {
        titel = ""
        bild = NSData()
        farbe = NSData()
        datum = NSDate()
    }
    
    func convertToDictionary() -> [String : AnyObject] {
        return ["titel": titel, "bild": bild, "datum": datum, "farbe": farbe]
    }
    
    class func fromDictionary(dictionary: [String : AnyObject]) -> WatchItem {
        var newWatchItem = WatchItem()
        newWatchItem.titel = dictionary["titel"] as! String
        newWatchItem.bild = dictionary["bild"] as! NSData
        newWatchItem.datum = dictionary["datum"] as! NSDate
        newWatchItem.farbe = dictionary["farbe"] as! NSData
        return newWatchItem
    }
    
    var image: UIImage {
        get{
            return UIImage(data: bild) ?? UIImage()
        }
        set{
            bild = UIImagePNGRepresentation(newValue)
        }
    }
    
    var color: UIColor {
        get{
            return NSKeyedUnarchiver.unarchiveObjectWithData(farbe) as? UIColor ?? UIColor.blackColor()
        }
        set{
            farbe = NSKeyedArchiver.archivedDataWithRootObject(newValue)
        }
    }
    
}