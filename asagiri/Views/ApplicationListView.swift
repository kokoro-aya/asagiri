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
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let app1 = Application(jobDescription: JobDescription(title: "junior DevOps", company: Company(name: "Company 1", website: "company.com"), type: CareerType(name: "DevOps")))
        
        let app2 = Application(jobDescription: JobDescription(title: "Fullstack developer", company: Company(name: "Company 1", website: "company.com"), type: CareerType(name: "Fullstack")))
        
        previewContainer.mainContext.insert(app1)
        previewContainer.mainContext.insert(app2)
        
        return ApplicationListView()
            .modelContainer(previewContainer)
    }
}
