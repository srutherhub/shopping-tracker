//
//  Receipt.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//

import Foundation


class Receipt {
    var location:SLocation
    var transaction:STransaction
    var items:[SItem]
    
    init(location: SLocation,transaction:STransaction,items:[SItem]) {
        self.location = location
        self.transaction = transaction
        self.items = items
    }
    
}


struct SLocation {
    var storeName:String;
    var address:String;
    var city:String;
    var state:String;
    var zip:String;
}

struct SItem {
    var name:String;
    var quantity:Double;
    var price:Double;
    var total:Double;
    var units:WeightUnits?
    var category:EItem
}


struct STransaction {
    var date:Date;
    var time:String
    var subtotal:Double;
    var total:Double;
    var tax:Double;
}

enum WeightUnits: String, RawRepresentable {
    case kilogram
    case gram
    case pound
    case ounce
    case fluid_ounce
    case gallon
    case quart
    case liter
}

enum EItem:String,RawRepresentable {
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
