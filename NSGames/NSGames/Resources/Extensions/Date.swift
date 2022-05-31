//
//  Date.swift
//  NSGames
//
//  Created by Rishat Latypov on 14.03.2022
//

import Foundation

extension Date {
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: d)
    }

    static func toString(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        var result = ""
        if Calendar.current.isDateInToday(date) {
            result += "Сегодня, "
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            if Calendar.current.isDateInYesterday(date) {
                result += "Вчера, "
                dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            }
            dateFormatter.accessibilityLanguage = "Russian"
        }
        return result + dateFormatter.string(from: date)
    }
}
