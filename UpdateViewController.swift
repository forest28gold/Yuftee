//
//  UpdateViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 03/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit
import EventKit

class UpdateViewController : NavPageViewController {
    
    var update: Update? {
        didSet {
            author = update!.getBusiness()
            calendarButtonActions = [:]
        }
    }
    var author: Business?
    var calendarButtonActions: [Int:()->()] = [:]
    
    var enableCalendarAlert: AlertBox?
    var eventAddedAlert: AlertBox?
    
    @IBOutlet weak var updateTitle: UILabel!
    @IBOutlet weak var updateBody: UITextView!
    @IBOutlet weak var updateSubtitle: UILabel!
    
    var addToCalBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        self.showBurger = false
        super.viewDidLoad()
        self.navigationItem.title = "Message"
        
        let calBtn = UIImage(named: "calendar")
        addToCalBtn = UIBarButtonItem(image: calBtn, style: .Plain, target: self, action: "calendarButtonClicked")
        addToCalBtn.width = 150

        self.navigationItem.rightBarButtonItem = addToCalBtn
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTitle.text = update?.title
        self.updateBody.text = update?.body
        self.updateSubtitle.text = TimeAgo.sinceDate(update!.date, numericDates: true)

        if update!.isEvent() {
            self.navigationItem.rightBarButtonItem = addToCalBtn
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func calendarButtonClicked () {
        
        Events.sharedInstance.requestAccess({ (granted: Bool, error: NSError!) in
            if granted {
                let cals = Events.sharedInstance.getCalendars()
                
                if objc_getClass("UIAlertController") != nil {
                    // Handle it in an iOS8 way
                    let alertController = UIAlertController(title: "Add Event", message: "Select calendar.", preferredStyle: .ActionSheet)
                    
                    for cal in cals {
                        alertController.addAction(UIAlertAction(title: cal.title, style: .Default, handler: { (action: UIAlertAction!) in
                            // Not sure about this. Better to use delegates to avoid scope issues? Seems to work as is.
                            self.addToCal(cal)
                        }))
                    }
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // Use iOS 7 UIActionSheet
                    var alertController = UIActionSheet(title: "Add Event to Calendar", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
                    for cal in cals {
                        self.calendarButtonActions[alertController.addButtonWithTitle(cal.title)] = {
                            self.addToCal(cal)
                        }
                    }
                    alertController.showInView(self.view)
                }
                
            } else {
                self.enableCalendarAlert = AlertBox(delegate: self, title: "Error", message: "Please enable access to calendar in Privacy Settings.")
                self.enableCalendarAlert!.addButton(title: "OK", style: .Default, handler: nil)
                self.enableCalendarAlert!.show()
            }
        })

    }

    func addToCal (calendar: EKCalendar) {

        let success = Events.sharedInstance.addEvent(forCalendar: calendar, update: self.update!)
        
        if success {
            self.eventAddedAlert = AlertBox(delegate: self, title: "Added", message: "Event has been added to your calendar.")
            self.eventAddedAlert!.addButton(title: "OK", style: .Default, handler: nil)
            self.eventAddedAlert!.show()
        }
        
    }

}

// MARK - UIActionSheetDelegate
extension UpdateViewController: UIActionSheetDelegate {
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if let callback = calendarButtonActions[buttonIndex] {
            callback()
        }
    }

}
