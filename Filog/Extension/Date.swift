//
//  Date.swift
//  Filog
//
//  Created by Jiyoung Park on 3/27/25.
//

import SwiftUI

extension Date {
    // MARK: 원하는 format만 주입하면 string 반환
    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: 캘린더의 컴포넌트를 가져오는 extension(eg. Date().get(.month) -> 오늘 날짜에 해당하는 월 반환)
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    // MARK: 컴포넌트에 해당하는 Date 반환
    static func date(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        if let customDate = Calendar.current.date(from: components) {
            return customDate
        }
        return Date()
    }
}
