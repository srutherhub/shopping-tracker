//
//  ReceiptView.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/14/25.
//

import SwiftUI

struct ReceiptView:View {
    @State var receipt:Receipt
    @State var name:String
    @State var date:Date
    @State var subtotal:String
    @State var total:String
    @State var tax:String
    
    init(receipt:Receipt){
        self.receipt = receipt
        _name = .init(initialValue: receipt.location.storeName)
        _date = .init(initialValue: convertISOStringToDate(isoString:receipt.transaction.date) ?? Date())
        _subtotal = .init(initialValue: String(format: "%.2f",receipt.transaction.subtotal))
        _total = .init(initialValue: String(format: "%.2f",receipt.transaction.total))
        _tax = .init(initialValue: String(format: "%.2f",receipt.transaction.tax))
    }
    
    var body: some View {
        VStack( alignment:.leading,spacing:16) {
            ScrollView(.vertical){
                HStack{
                    Text("Review receipt")
                    Spacer()
                    Text("Items: \(receipt.items.count)")
                }
                VStack(alignment: .leading){
                    Text("Store name")
                    TextField("\(receipt.location.storeName)",text: $name)
                }
                DatePicker("Date", selection: $date).datePickerStyle(.automatic)
                VStack(alignment: .leading) {
                    Text("Total")
                    TextField("Total", text: $total).keyboardType(.numberPad)
                }
                HStack{
                    VStack(alignment: .leading){
                        Text("Subtotal")
                        TextField("Subtotal", text: $subtotal).keyboardType(.numberPad)
                    }
                    VStack(alignment: .leading){
                        Text("Tax")
                        TextField("Tax", text: $tax).keyboardType(.numberPad)
                    }
                }
            } }.textFieldStyle(.roundedBorder)
    }
}



#Preview {
    ReceiptView(receipt: Receipt(location: Location(storeName: "HyVee", address: "123 Main St", city: "Madison", state: "Wi", zip: "53715"), transaction: Transaction(date: "12/12/2025", time: "11:00AM", subtotal: 70.90, total: 81.00, tax: 9.80), items: [Item(name: "Milk", quantity: 1, price: 2.99, total: 2.99, category: .dairy_eggs)]))
}
