//
//  DateTimeLibrary.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/5/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    
    /// Date with hours
    case dateWithTime = "yyyy-MM-dd HH:mm:ss"
    
    /// Date
    case date = "dd-MMM-yyyy"
}

extension NSObject {
    
    /// Convert String to Date
    func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatType.date.rawValue // Your date format
        let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
        return serverDate
    }
    
    /// Convert Date to String
    func convertToString(date: Date, dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue // Your New Date format as per requirement change it own
        
        let newDate: String = dateFormatter.string(from: date) // pass Date here
        print(newDate) // New formatted Date string
        
        return newDate
    }
    
    /// Diviation calculation
    func convertToSeconds(timeString: String, dateFormat type: DateFormatType) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        
        let date: Date = dateFormatter.date(from: timeString)!
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        // let sec = comp.second
        
        let totalSeconds = ((hour! * 60) * 60) + (minute! * 60) //+ sec!
        
        return totalSeconds
    }
    
    
    /// To Show the Date in String format
    func convertToShowFormatDate(dateString: String) -> String {
        
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        
        let serverDate: Date = dateFormatterDate.date(from: dateString)! //according to date format your date string
        
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "yyyy-MM-dd hh:mm a" //Your New Date format as per requirement change it own
        let newDate: String = dateFormatterString.string(from: serverDate) //pass Date here
        print(newDate) // New formatted Date string
        
        return newDate
    }
    
}

