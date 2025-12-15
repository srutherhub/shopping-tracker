//
//  Shopping_TrackerApp.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//

import SwiftUI
import SwiftData

@main
struct Shopping_TrackerApp: App {
    @StateObject private var session = AppSession()
    
    let modelContainer: ModelContainer
        
        init() {
            do {
                modelContainer = try ModelContainer(
                    for: Receipt.self,
                    Location.self,
                    Item.self,
                    Transaction.self
                )
            } catch {
                fatalError("Could not initialize ModelContainer: \(error)")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environmentObject(session)
                .task {
                    await session.start()
                }
        }
    }
}

@MainActor
final class AppSession: ObservableObject {
    let auth = AuthService()
    let api: APIClient

    @Published var ready = false

    init() {
        self.api = APIClient(auth: auth)
    }

    func start() async {
        do {
            _ = try await auth.load()
            ready = true
        } catch {
            print("Failed to start session:", error)
        }
    }
}

