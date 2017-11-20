//
//  Events.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 18/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import EventKit

// TY to http://ahoj.io/creating-calendars-and-events-using-eventkit-on-ios-6

class Events {

    class var sharedInstance : Events {
        struct Singleton {
            static let instance = Events()
        }
        return Singleton.instance
    }
    
    var eventStore = EKEventStore()
    
    func requestAccess(callback: EKEventStoreRequestAccessCompletionHandler!) {
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: callback)
    }
    
    func getCalendars () -> [EKCalendar] {
        let calendars : [EKCalendar] = self.eventStore.calendarsForEntityType(EKEntityTypeEvent) as [EKCalendar]
        return calendars
    }

    func addEvent (forCalendar calendar: EKCalendar, update: Update) -> Bool {
        var event = EKEvent(eventStore: eventStore)
        
        event.calendar = calendar
        event.location = update.getBusiness().name
        event.title = update.title
        event.startDate = update.eventTime!
        event.endDate = event.startDate.dateByAddingTimeInterval(1800)
        event.notes = "\(update.body)\n\nEvent added by Yuftee"
        
        var error = NSErrorPointer()
        if eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: error) {
            return true
        } else {
            return false
        }
    }

    // old
    func addEvent (forCalendar calendar: EKCalendar, when: NSDate, event title: String, businessName location: String, body: String) -> Bool {
        var event = EKEvent(eventStore: eventStore)
        
        event.calendar = calendar
        event.location = location
        event.title = title
        event.startDate = NSDate()
        event.endDate = event.startDate.dateByAddingTimeInterval(1800)
        event.notes = "\(body)\n\nEvent added by Yuftee"
        
        var error = NSErrorPointer()
        if eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: error) {
            return true
        } else {
            return false
        }

    }
    
    func addEvent (when: NSDate, event title: String, businessName location: String) -> Bool {
        
        var event = EKEvent(eventStore: eventStore)
        
        var calendar: EKCalendar?
        
        var calendarIdentifier = NSUserDefaults.standardUserDefaults().valueForKey("YufteeCalendarID")as String?;()
        
        if (calendarIdentifier != nil) {
            calendar = eventStore.calendarWithIdentifier(calendarIdentifier!)
        }
        
        if (calendar == nil) {
            
            calendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: eventStore)
            calendar!.title = "Yuftee"
            
            // this is stupid
            // and so is swift for making me do .value
            
            var calendarSource: EKSource?
            for source in eventStore.sources() as [EKSource] {
                if source.sourceType.value == EKSourceTypeLocal.value {
                    calendarSource = source;
                    break;
                }
            }
            
            if calendarSource == nil {
                return false
            }
            
            calendar!.source = calendarSource
            calendarIdentifier = calendar!.calendarIdentifier
            
            var error = NSErrorPointer()
            
            if eventStore.saveCalendar(calendar!, commit: true, error: error) {
                NSUserDefaults.standardUserDefaults().setObject(calendarIdentifier, forKey: "YufteeCalendarID")
            } else {
                return false
            }
            
        }
    
        if (calendar == nil) {
            return false
        }
        
        event.calendar = calendar!
        event.location = location
        event.title = title
        event.startDate = NSDate()
        event.endDate = event.startDate.dateByAddingTimeInterval(1800)
        event.notes = title
        
        var error = NSErrorPointer()
        if eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: error) {
            return true
        } else {
            return false
        }

    }
    
    
}
