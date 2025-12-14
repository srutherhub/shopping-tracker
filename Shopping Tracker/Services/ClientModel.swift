//
//  ClientModel.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//
import Foundation
import CryptoKit
import SwiftUI

enum ClientError: Error, LocalizedError {
    case invalidURL
    case encodingFailed(Error)
    case networkFailed(Error)
    case noAuthHeader
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .encodingFailed(let err): return "Encoding failed: \(err.localizedDescription)"
        case .networkFailed(let err): return "Network error: \(err.localizedDescription)"
        case .noAuthHeader: return "Authorization header missing"
        case .unknown: return "Unknown error"
        }
    }
}

struct RequestError: Decodable {
    var error:String
    var message:String
    var status:Int
}

struct RequestSignature: Encodable{
    var bundle_id:String
    var device_id:String
    var datetime:Int
    var signature:String
}

struct SessionManager {
    var accessToken: String?
}

final class ClientModel {
    static private var baseUrl: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String, !host.isEmpty else {
            fatalError("API_BASE_URL not set in Info.plist")
        }
        #if DEBUG
        return "http://\(host)"
        #else
        return "https://\(host)"
        #endif
    }

    static var session:SessionManager = SessionManager()
    
    
    static func createRequestSignature() -> RequestSignature {
        let timestamp = Int(Date().timeIntervalSince1970)
        let appbundle = Bundle.main.bundleIdentifier
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        let secretBase64 = "mEyzK0H5DEYIePztJZof/DD71Cb8RQi5bN5kG60SnPjlGCawP+pMN29qHBw+XXCYHCELtgJALYMMV24Cgu4Qgg=="
                guard let secretData = Data(base64Encoded: secretBase64) else {
                    fatalError("Invalid secret key")
                }
        let secret = SymmetricKey(data: secretData)
        let message = Data("\(appbundle ?? "")|\(String(timestamp))|\(deviceId ?? "")".utf8)
        let signature = HMAC<SHA256>.authenticationCode(for: message, using: secret)
        let hmacString = signature.map { String(format: "%02hhx", $0) }.joined()
        return RequestSignature(bundle_id: appbundle ?? "", device_id: deviceId ?? "", datetime: timestamp, signature: hmacString)
    }
    
    static func getAccesToken() async throws{
        guard let url = URL(string: ClientModel.baseUrl + "/auth/register") else {
            throw ClientError.invalidURL
        }
        let requestBody = ClientModel.createRequestSignature()
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            request.httpBody = bodyData
        } catch {
            throw ClientError.encodingFailed(error)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                        if let authHeader = httpResponse.value(forHTTPHeaderField: "Authorization") {
                            let token = authHeader.replacingOccurrences(of: "Bearer ", with: "")
                            ClientModel.session.accessToken = token
                        } else {
                            let decoded = try JSONDecoder().decode(RequestError.self, from: data)
                            print(decoded)
                            throw ClientError.noAuthHeader
                        }
                    }
        } catch {
            throw ClientError.networkFailed(error)
        }

        
    }
}



