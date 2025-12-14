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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
