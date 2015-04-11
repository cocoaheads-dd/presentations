//
//  Rows.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import WatchKit


class TableRow: NSObject {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var backgroundLabel: WKInterfaceGroup!
    
    var item: WatchItem! {
        didSet{
            titleLabel.setText(item.titel)
            var dateF = NSDateFormatter()
            dateF.dateFormat = "hh:MM:ss"
            timeLabel.setText(dateF.stringFromDate(item.datum))
            backgroundLabel.setBackgroundColor(item.color)
        }
    }
}

class ActionRow: NSObject {
    
    @IBOutlet weak var actionLabel: WKInterfaceLabel!
    
    var action: String {
        set{
            actionLabel.setText(newValue)
        }
        get{
            return ""
        }
    }
}