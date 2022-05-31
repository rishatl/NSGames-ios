//
//  MyJSONDecoder.swift
//  NSGames
//
//  Created by Rishat Latypov on 06.05.2022
//

import Foundation

class MyJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
}
