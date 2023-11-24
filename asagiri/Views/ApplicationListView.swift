//
//  ApplicationListView.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import SwiftUI
import SwiftData

struct ApplicationListView: View {
    
    @Query private var applications: [Application]
    
    var body: some View {
        Text("\(applications.count)")
    }
}

#Preview {
    
    
    var previewContainer: ModelContainer = {
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
            fatalError("Could not create ModelContainer for preview: \(error)")
        }
    }()
    
    let app = Application(jobDescription: JobDescription(title: "junior DevOps", type: CareerType(name: "DevOps")))
    
    previewContainer.mainContext.insert(app)
    
    return ApplicationListView()
        .modelContainer(previewContainer)
}
