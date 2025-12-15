//
//  Receipt.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//
import Foundation
import SwiftData

@Model
final class Receipt: Sendable {
    var id: UUID = UUID()
    var location: Location
    var transaction: Transaction
    var items: [Item]
    var imgId:UUID?
    
    init(location: Location, transaction: Transaction, items: [Item]) {
        self.location = location
        self.transaction = transaction
        self.items = items
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.location = try container.decode(Location.self, forKey: .location)
        self.transaction = try container.decode(Transaction.self, forKey: .transaction)
        self.items = try container.decode([Item].self, forKey: .items)
    }
}
extension Receipt: Codable {
    enum CodingKeys: String, CodingKey {
        case location, transaction, items
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
        try container.encode(transaction, forKey: .transaction)
        try container.encode(items, forKey: .items)
    }
}

@Model
final class Location : Sendable{
    var id: UUID = UUID()
    var storeName: String
    var address: String
    var city: String
    var state: String
    var zip: String
    
    init(storeName: String, address: String, city: String, state: String, zip: String) {
        self.storeName = storeName
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storeName = try container.decode(String.self, forKey: .storeName)
        self.address = try container.decode(String.self, forKey: .address)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.zip = try container.decode(String.self, forKey: .zip)
    }
}

extension Location: Codable {
    enum CodingKeys: String, CodingKey {
        case storeName, address, city, state, zip
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storeName, forKey: .storeName)
        try container.encode(address, forKey: .address)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zip, forKey: .zip)
    }
}

@Model
final class Item : Sendable{
    var id: UUID = UUID()
    var name: String
    var quantity: Double
    var price: Double
    var total: Double
    var units: WeightUnits?
    var category: EItem
    
    init(name: String, quantity: Double, price: Double, total: Double, units: WeightUnits? = nil, category: EItem) {
        self.name = name
        self.quantity = quantity
        self.price = price
        self.total = total
        self.units = units
        self.category = category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.quantity = try container.decode(Double.self, forKey: .quantity)
        self.price = try container.decode(Double.self, forKey: .price)
        self.total = try container.decode(Double.self, forKey: .total)
        if let unitsString = try container.decodeIfPresent(String.self, forKey: .units) {
            self.units = WeightUnits(rawValue: unitsString)
        } else {
            self.units = nil
        }
        self.category = try container.decode(EItem.self, forKey: .category)
    }
}

extension Item: Codable {
    enum CodingKeys: String, CodingKey {
        case  name, quantity, price, total, units, category
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(price, forKey: .price)
        try container.encode(total, forKey: .total)
        try container.encode(units, forKey: .units)
        try container.encode(category, forKey: .category)
    }
}

@Model
final class Transaction :Sendable {
    var id: UUID = UUID()
    var date: String
    var time: String
    var subtotal: Double
    var total: Double
    var tax: Double
    
    init(date: String, time: String, subtotal: Double, total: Double, tax: Double) {
        self.date = date
        self.time = time
        self.subtotal = subtotal
        self.total = total
        self.tax = tax
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.time = try container.decode(String.self, forKey: .time)
        self.subtotal = try container.decode(Double.self, forKey: .subtotal)
        self.total = try container.decode(Double.self, forKey: .total)
        self.tax = try container.decode(Double.self, forKey: .tax)
    }
}

extension Transaction: Codable {
    enum CodingKeys: String, CodingKey {
        case date, time, subtotal, total, tax
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(time, forKey: .time)
        try container.encode(subtotal, forKey: .subtotal)
        try container.encode(total, forKey: .total)
        try container.encode(tax, forKey: .tax)
    }

}

enum WeightUnits: String, Codable {
    case kilogram
    case gram
    case pound
    case ounce
    case fluid_ounce
    case gallon
    case quart
    case liter
}

enum EItem: String, Codable {
    case produce
    case meat_seafood
    case dairy_eggs
    case pantry_grains
    case snacks_sweets
    case beverages
    case sodas
    case frozen
    case packaged
    case prepared_convience
    case bakery
    case condiments
    case household_cleaning
    case personal_care
    case other
}

