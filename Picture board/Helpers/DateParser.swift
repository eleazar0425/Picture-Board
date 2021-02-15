//
//  DateParser.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation


class DateParser {
    
    static func parse(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss"
        let date = dateFormatter.date(from: date.replacingOccurrences(of: "GMT-0500 (Colombia Standard Time)", with: ""))
        if date == nil {
            return nil
        }
        
        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "MMM dd"
        return shortFormatter.string(from: date!)
    }

}

