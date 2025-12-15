//
//  Helpers.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/14/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

func convertISOStringToDate(isoString: String) -> Date? {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    return isoFormatter.date(from: isoString)
}
