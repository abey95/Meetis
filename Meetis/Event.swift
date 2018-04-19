//
//  Event.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/10/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit


enum EventCategory:String {
    case school, work, personal, travel, family
    
     static let allValues = [school, work, personal, travel, family]
}

class Event: NSObject {
    
    // Instance Variables
    var title:String?           // name of the event
    var nextDate:DateComponents?// component of the recurring event
    var days:[Bool]             // days of the week the event is active
    var priority:String?        // priority of the event: "High"
    var category: EventCategory // category of the event
    var active: Bool            // true if active, false otherwise
    var time: String?           // string representation of time
    
    let charOfDays = ["Su", "M", "T", "W", "R", "F", "Sa"]
    
    // This function is called to initialize an object instantiated from the MapAnnotation class
    init(title:String, days:[Bool], time:String, priority:String, category: EventCategory, active: Bool ) {
        self.title = title
        self.days = days
        let hours_minutes = time.split(separator: ":")
        self.time = time
        self.priority = priority
        self.category = category
        self.active = active
        super.init()
        self.nextDate = DateComponents(hour: Int(hours_minutes[0]), minute:Int(hours_minutes[1]), weekday: nextDateOrdinal())
    }
    
    
    /*
     * /// Returns the amount of seconds from current date to another date
     */
    func getTimeUntil() -> Int {
        return 1
        //return Calendar.current.dateComponents([.second], from: nextDate!.date!, to: Date()).seconds ?? 0
    }
    
    /*
     * accesses the dict_Notes and returns all of the filenames of the notes
     */
    func getNotes() -> [String] {
        return ["lol"]
    }
    
    /*
     * returns a filename for newly created notes for the event
     */
    func makeNewFilename() -> String {
        return "lol"
    }
    
    /*
     * deactivates the event
     */
    func deactivate() {
        active = false
    }
    
    /*
        return the all fields in an object array
    */
    func toDict() -> [String : AnyObject] {
        var dict = [String: AnyObject]()
        dict["active"] = active as AnyObject
        dict["days"] = days as AnyObject
        dict["priority"] = priority as AnyObject
        dict["time"] = time as AnyObject
        dict["category"] = category.rawValue as AnyObject
        
        return dict
    }
    
    // returns the next active day
    private func nextDateOrdinal() -> Int {
        let cur_ordinal = 0
        
        for i in 0...days.count {
            if days[(cur_ordinal + i) % days.count] {
                return i
            }
        }
        return -1
    }
    
    func getDateString() -> String {
        var days_string = String()
        for i in 0...days.count - 1 {
            if days[i] {
                days_string.append(charOfDays[i] + " ")
            }
        }
        return time! + " " + days_string
    }
    
}
