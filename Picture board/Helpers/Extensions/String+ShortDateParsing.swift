//
//  String+ShortDateParsing.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation


extension String {
    var shortDate: String  {
        
        if let parsedDate =  DateParser.parse(date: self){
            return parsedDate
        }
        
        return self
    }
}
