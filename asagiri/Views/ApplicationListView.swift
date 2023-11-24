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
        ForEach(applications) { app in
            ApplicationCard(application: app)
                .padding([.leading, .trailing], 10)
        }
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
    
    // Remove existing applications just for preview
    do {
        try previewContainer.mainContext.delete(model: Application.self)
    } catch {
        fatalError(error.localizedDescription)
    }
    
    let app1 = Application(jobDescription: JobDescription(title: "junior DevOps", company: Company(name: "Company 1", website: "company.com"), type: CareerType(name: "DevOps")))
    
    let app2 = Application(jobDescription: JobDescription(title: "Fullstack developer", company: Company(name: "Company 1", website: "company.com"), type: CareerType(name: "Fullstack")))
    
    previewContainer.mainContext.insert(app1)
    previewContainer.mainContext.insert(app2)
    
    return ApplicationListView()
        .modelContainer(previewContainer)
}
