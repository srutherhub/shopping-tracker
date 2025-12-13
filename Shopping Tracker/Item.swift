//
//  Item.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
