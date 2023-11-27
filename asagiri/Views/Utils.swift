//
//  Utils.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import Foundation
import SwiftData


// The common function across various preview views to initialize an empty data scheme before rendering the scene
@MainActor
func initializePreviewContainer() -> ModelContainer {
    let previewContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            
            Application.self,
            Company.self,
            Resume.self,
            CoverLetter.self,
            JobDescription.self,
            CareerType.self,
            Event.self,
            Tag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer for preview: \(error)")
        }
    }()
    
    // Remove existing applications just for preview
    do {
        try previewContainer.mainContext.delete(model: Application.self)
    } catch {
        fatalError(error.localizedDescription)
    }
    
    return previewContainer
}
