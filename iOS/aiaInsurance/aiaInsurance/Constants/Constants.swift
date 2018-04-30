//
//  Constants.swift
//  aiaInsurance
//
//  Created by Talha Qamar on 29/4/18.
//  Copyright © 2018 Devtalha.com. All rights reserved.
//

import Foundation
import UIKit

class Constants
{
    
   static let startURL = "https://api.imgur.com/3/gallery/t/" // URL for getting images based on user text
   static let endURL = "/week/1" // top images currently
 
    
    // This method actually parse the Date into required format
    static func parseDate(_ date: Double) -> String
    {
        let someDateTime = Date(timeIntervalSinceReferenceDate: date)
        print(someDateTime)
        let dateStringFormatter = DateFormatter()
        //  dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateStringFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let formattedDate = dateStringFormatter.string(from: someDateTime)
        
        return formattedDate
    }
}
