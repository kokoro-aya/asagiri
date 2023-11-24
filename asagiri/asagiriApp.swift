//
//  asagiriApp.swift
//  asagiri
//
//  Created by irony on 16/11/2023.
//

import SwiftUI
import SwiftData

@main
struct asagiriApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            
            Application.self,
            Company.self,
            Resume.self,
            CoverLetter.self,
            JobDescription.self,
            CareerType.self,
            Event.self
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
        .modelContainer(sharedModelContainer)
    }
}
