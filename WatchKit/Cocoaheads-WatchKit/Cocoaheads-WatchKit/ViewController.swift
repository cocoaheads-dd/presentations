//
//  ViewController.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//
//
// Icons from http://brsev.deviantart.com/art/Mnml-Icon-Set-106367676
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    var items: [Item] = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 65.0/255.0, green: 131.0/255.0, blue: 215.0/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        items = fetchItemsFromDB()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemsChanged:", name: ITEMSCHANGEDNOTIFICATION, object: nil)
    }
    
    // This is called when the Notification is posted
    func itemsChanged(notification: NSNotification) {
        items = fetchItemsFromDB()
        tableView.reloadData()
    }
    
    // MARK: - Table View DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default") as! DefaultTableViewCell
        cell.item = items[indexPath.row]
        return cell
    }
    
    // MARK - Table View Delegate
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            managedObjectContext.deleteObject(items[indexPath.row])
            managedObjectContext.save(nil)
            items = fetchItemsFromDB()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Löschen"
    }

    // MARK: - IBActions
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Neues Item", message: "Bitte geben Sie einen Titel ein.", preferredStyle: .Alert)
        
        var okAction = UIAlertAction(title: "Ok", style: .Default) { action in
            // Speicher neuen Datensatz
            var newItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedObjectContext) as! Item
            newItem.titel = (alert.textFields?.first as? UITextField)?.text ?? ""
            newItem.datum = NSDate()
            newItem.image = randomImage()
            newItem.color = UIColor.random()
            managedObjectContext.save(nil)
            self.items = fetchItemsFromDB()
            self.tableView.reloadData()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Titel"
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}

// The Table View Cell in the Controller
class DefaultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: Item? {
        didSet{
            pictureImageView.image = item?.image
            titleLabel.text = item?.titel
            let dateF = NSDateFormatter()
            dateF.dateFormat = "dd.MM.yyyy HH:mm:SS"
            dateLabel.text = dateF.stringFromDate(item?.datum ?? NSDate())
            
            backgroundColor = item?.color
        }
    }
}


