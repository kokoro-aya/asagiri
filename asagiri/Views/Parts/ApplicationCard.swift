//
//  ApplicationCard.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI

struct ApplicationCard: View {
    
    let app: Application
    
    init(application: Application) {
        self.app = application
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(app.jobDescription.title)
                        .font(.headline)
                    Text(app.jobDescription.company.name)
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(app.status.description)
                        .font(.subheadline)
                    Text(app.dateCreated.formatted(.dateTime.day().month().year()))
                        .font(.caption)
                }
            }
            Divider()
        }
    }
}
