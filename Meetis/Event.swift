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
    
    // This function is called to initialize an object instantiated from the MapAnnotation class
    init(title:String, days:[Bool], time:String, priority:String, category: EventCategory, active: Bool ) {
        self.title = title
        self.days = days
        let hours_minutes = time.split(separator: ":")
        self.priority = priority
        self.category = category
        self.active = active
        super.init()
        self.nextDate = DateComponents(hour: Int(hours_minutes[0]), minute:Int(hours_minutes[1]), weekday: nextDateOrdinal())
    }
    
    
    /*
     * returns the number of seconds to the event from the current time
     */
    func getTimeUntil() -> Int {
        return 1;
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
        return "8:00-9:15am MWF"
    }
    
}
