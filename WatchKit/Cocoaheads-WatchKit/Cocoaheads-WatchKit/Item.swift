//
//  Cocoaheads_WatchKit.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var bild: NSData
    @NSManaged var datum: NSDate
    @NSManaged var farbe: NSData
    @NSManaged var titel: String

}
