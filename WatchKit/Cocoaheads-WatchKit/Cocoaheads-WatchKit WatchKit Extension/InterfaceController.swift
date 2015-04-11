//
//  InterfaceController.swift
//  Cocoaheads-WatchKit WatchKit Extension
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import WatchKit
import Foundation

var vorschläge: [String] {
    return ["Wurst", "Käse", "Brot", "Butter", "Marmelade", "Nutella", "Nudeln", "Batterien", "Swag"]
}

class MainMenüController: WKInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Zum besseren Debuggen
        WKInterfaceController.openParentApplication([:], reply: { _,_ in
            
        })
    }
    
    @IBAction func addNewElement() {
        addNewElementInController(self) { success in }
    }
    
}

class InterfaceController: WKInterfaceController {

    var items: [WatchItem]!
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var warnLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Load the items
        reloadAllItems()
    }
    
    
    
    func reloadAllItems() {
        Bus.fetchItems({ items in
            self.items = items
            
            var rowTypes = [String]()
            for i in 0..<self.items.count { rowTypes.append("default") }
            rowTypes.append("action")
            
            self.table.setRowTypes(rowTypes)
            
            for element in enumerate(items) {
                var row = self.table.rowControllerAtIndex(element.index) as! TableRow
                row.item = element.element
            }
            
            if self.items.count <= 0 {
                self.warnLabel.setText("Leider keine Daten gefunden.")
                self.warnLabel.setHidden(false)
            }
            else {
                self.warnLabel.setHidden(true)
            }
            
            var row = self.table.rowControllerAtIndex(self.items.count) as! ActionRow
            row.action = "Hinzufügen"
        })
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        if rowIndex < self.items.count {
            pushControllerWithName("detail", context: items[rowIndex])
        }
        else {
            addNewElementInController(self) { success in
                self.reloadAllItems()
            }
        }
    }

    @IBAction func pressedDeleteButton() {
        
    }
}


class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var titel: WKInterfaceLabel!
    @IBOutlet weak var datum: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        if let item = context as? WatchItem {
            setTitle(item.titel)
            imageView.setImageNamed("\(item.titel.hash)")
            titel.setText(item.titel)
            
            var dateF = NSDateFormatter()
            dateF.dateFormat = "hh:MM:ss"
            datum.setText(dateF.stringFromDate(item.datum))
            
            var backgroundC = NSKeyedUnarchiver.unarchiveObjectWithData(item.farbe) as? UIColor ?? UIColor.whiteColor()
            
            titel.setTextColor(backgroundC)
        }
    }
    
}


func addNewElementInController(controller: WKInterfaceController, completion: (success: Bool) -> ()) {
    
    controller.presentTextInputControllerWithSuggestions(vorschläge, allowedInputMode: .Plain) {
        results in
        
        if results != nil && results.count > 0 {
            let newItem = WatchItem()
            newItem.titel = results.first as! String
            newItem.datum = NSDate()
            
            Bus.addNewItem(newItem, completion: { success in
                
                completion(success: success)
                
            })
        }
        
    }
}