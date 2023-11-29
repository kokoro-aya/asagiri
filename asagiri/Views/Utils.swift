////  Licensed under GPL v3 License.
//
//  kokoro-aya/asagiri
//  Copyright (c) 2023 . All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with Foobar. If not, see <https://www.gnu.org/licenses/>.
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
        try previewContainer.mainContext.delete(model: Company.self)
        try previewContainer.mainContext.delete(model: Resume.self)
        try previewContainer.mainContext.delete(model: CoverLetter.self)
        try previewContainer.mainContext.delete(model: JobDescription.self)
        try previewContainer.mainContext.delete(model: CareerType.self)
        try previewContainer.mainContext.delete(model: Event.self)
        try previewContainer.mainContext.delete(model: Tag.self)
    } catch {
        fatalError(error.localizedDescription)
    }
    
    return previewContainer
}
