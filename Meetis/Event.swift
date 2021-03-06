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
    static let rawValues =  [school.rawValue, work.rawValue, personal.rawValue, travel.rawValue, family.rawValue]
}

struct Note {
    
    // name where the file is stored in the user's document directory
    // to obtain jpeg of the views the path is filename + "_n.png" where n is the note number of the current session
    // to obtain the audio recording the path is filename + "_recording.m4a"
    var filename: String!
    var text: String! // user input annotations
    var numPages: Int!
    var date: Date!
    
}

class Event: NSObject {
    
    // Instance Variables
    var title:String!           // name of the event
    var dateInfo:DateComponents!// component of the recurring event
    var days:[Bool]!             // days of the week the event is active
    var priority:String!        // priority of the event: "High"
    var category: EventCategory // category of the event
    var active: Bool!            // true if active, false otherwise
    var time: String!           // string representation of time
    var nextDate: Date!         // date object for the nearest event in the future
    var notes = [String]()      // all the file names related to the current event used for look up in dict_notes
    
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
        self.dateInfo = DateComponents(hour: Int(hours_minutes[0]), minute:Int(hours_minutes[1]), weekday: nextDateOrdinal())
       updateToNextDate()
    }
    
    //updates the next Date to the next occurence matching the date ordinal
    func updateToNextDate() {
        let hours_minutes = time.split(separator: ":")
        self.dateInfo = DateComponents(hour: Int(hours_minutes[0]), minute:Int(hours_minutes[1]), weekday: nextDateOrdinal())
        
        
         nextDate = Calendar.current.nextDate(after: Date(), matching: dateInfo!, matchingPolicy: Calendar.MatchingPolicy.strict)
    }
    
    func apppendToNotes(filename: String) {
        notes.append(filename)
    }
    
    
    /*
     * Returns the amount of seconds from current date to another date
     *  MAY RETURN NEGATIVE
     */
    func getTimeUntil() -> Double {
        return nextDate!.timeIntervalSinceNow.magnitude
        
        
    }
    
    // updates the nextDate object to be the next active date
    func updateNextDate () {
        nextDate = Calendar.current.nextDate(after: nextDate!, matching: dateInfo!, matchingPolicy: Calendar.MatchingPolicy.nextTime)
    }
    
    
    /*
     * returns a filename for newly created notes for the event
     */
    func makeNewFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        let filename = "\(title!)_\(dateStr)"
        return filename.replacingOccurrences(of: " ", with: "_")
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
        dict["notes"] = notes as AnyObject
        
        return dict
    }
    
    // returns the next active day
    private func nextDateOrdinal() -> Int {
        let cur_ordinal = Calendar.current.component(.weekday, from: Date()) - 1
        
        for i in 0...days.count {
            if days[(cur_ordinal + i) % days.count] {
                return ((cur_ordinal + i) % days.count) + 1
            }
        }
        return -1
    }
    
    // Prints the time and the days the event is active. Ex: 12:00 M W F
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
