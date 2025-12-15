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

final class ClientModel {
    static var baseUrl: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String, !host.isEmpty else {
            fatalError("API_BASE_URL not set in Info.plist")
        }
#if DEBUG
        return "http://\(host)"
#else
        return "https://\(host)"
#endif
    }
    
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
}


actor AuthService {
    private(set) var accessToken: String?
    
    func load() async throws {
        self.accessToken = try await fetchToken()
    }
    
    func refresh() async throws {
        self.accessToken = try await fetchToken()
    }
    
    private func fetchToken() async throws -> String {
        guard let url = URL(string: ClientModel.baseUrl + "/auth/register") else {
            throw ClientError.invalidURL
        }
        
        let body = ClientModel.createRequestSignature()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard
            let http = response as? HTTPURLResponse,
            let header = http.value(forHTTPHeaderField: "Authorization")
        else {
            throw ClientError.noAuthHeader
        }
        
        return header.replacingOccurrences(of: "Bearer ", with: "")
    }
}

struct APIClient {
    let auth: AuthService

    func send(_ request: URLRequest) async throws -> Data {
        var request = request
        guard let token = await auth.accessToken else {
            throw ClientError.noAuthHeader
        }

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode == 401 {
            try await auth.refresh()
            return try await send(request)
        }

        return data
    }
}
