//
//  ReceiptViewModel.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/14/25.
//

import Foundation
import SwiftUI

final class ReceiptViewModel:ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var images:[UIImage] = []
    @Published var isParsingReceipt:Bool = false
    
    private var session: AppSession
    
    init(session: AppSession) {
            self.session = session
        }
    
    func performOCRonReceipt(image: UIImage) async ->  String {
        let ocrString = await performOCR(on: image)
        return ocrString
    }
    
    func getParsedReceipt(_ ocrString: String) async throws -> Receipt {
        var receiptResult:Receipt
        guard let url = URL(string: "\(ClientModel.baseUrl)/llm/receipts/parse") else {
            self.isParsingReceipt = false
            throw ClientError.invalidURL
        }
        struct RequestBody: Encodable {
                let text: String
            }
            
            let body = try JSONEncoder().encode(RequestBody(text: ocrString))
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        let data = try await session.api.send(request)
        do {
            receiptResult = try JSONDecoder().decode(Receipt.self, from: data)
        } catch let DecodingError.typeMismatch(type, context) {
            self.isParsingReceipt = false
            
            print("Type mismatch for \(type)")
            print("Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            print("Context: \(context.debugDescription)")
            
            throw ClientError.unknown
        } catch let DecodingError.keyNotFound(key, context) {
            self.isParsingReceipt = false
            
            print("Missing key: \(key.stringValue)")
            print("Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            
            throw ClientError.unknown
        } catch {
            self.isParsingReceipt = false
            print("Other error: \(error)")
            throw ClientError.unknown
        }
        return receiptResult
        
    }
}


struct ReceiptImage {
    var id:UUID=UUID()
    var image:UIImage
}
