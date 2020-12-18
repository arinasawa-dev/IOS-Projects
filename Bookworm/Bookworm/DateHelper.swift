//
//  DateHelper.swift
//  Bookworm
//
//  Created by Arin Asawa on 11/21/20.
//

import Foundation


struct DateHelper{
   static  func date2String(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

