//
//  Global Things.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import UIKit
import CoreData

var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

let ITEMSCHANGEDNOTIFICATION = "Items has been changed.."

var icons = ["1-adobe",
    "1-circle",
    "1-desktop",
    "1-office",
    "1-star",
    "1-start",
    "camera",
    "chrome",
    "digsby",
    "down",
    "email",
    "firefox",
    "folder",
    "gmail",
    "ie",
    "illustrator",
    "indesign",
    "maps",
    "music",
    "notes",
    "opera",
    "photoshop",
    "power",
    "preview",
    "recycle",
    "screenshot",
    "slideshow",
    "spreadsheet",
    "task",
    "toolbox",
    "wmp",
    "writing"]

func randomImage() -> UIImage {
    var index = Int(Int(arc4random()) % icons.count)
    return UIImage(named: icons[index] + ".png")!
}

func fetchItemsFromDB() -> [Item] {
    var request = NSFetchRequest(entityName: "Item")
    var erg = managedObjectContext.executeFetchRequest(request, error: nil) as! [Item]
    erg.sort { $0.titel < $1.titel }
    return erg
}