//
//  ApplicationCard.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct ApplicationCard: View {
    
    let app: Application
    
    @State var detailed: Bool = false
    
    init(application: Application) {
        self.app = application
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(app.jobDescription.title)
                        .font(.headline)
                    Text(app.jobDescription.company.name)
                        .font(.subheadline)
                }
                Spacer()
                
                    let lastEvent = app.lastEvent
                    
                    if (lastEvent != nil) {
                        let start = app.dateCreated.formatted(.dateTime.day().month().year())
                        let curr = lastEvent!.updateTime.formatted(.dateTime.day().month().year())
                        
                        Text("\(start) - \(curr)")
                            .font(.caption)
                            .padding(4)
                    } else {
                        Text(app.dateCreated.formatted(.dateTime.day().month().year()))
                            .font(.caption)
                            .padding(4)
                    }
            
            }
            HStack {
                if (app.resume != nil || app.cover != nil) {
//                    Text("Preview")
//                        .foregroundStyle(.gray)
                    if (app.resume != nil) {
                        Button {
                            
                        } label: {
                            Text("Resume")
                        }
                    }
                    if (app.cover != nil) {
                        Button {
                            
                        } label: {
                            Text("Cover")
                        }
                    }
                }
                Spacer()
                
                Button {
                    if (app.events.count > 0) {
                        detailed = !detailed
                    }
                } label: {
                    Label(app.status.description, systemImage: "")
                            .font(.subheadline)
                            .foregroundColor(app.status.color())
                    if (app.events.count > 0) {
                        Image(systemName: detailed ? "xmark" : "plus")
                            .foregroundColor(app.status.color())
                    }
                }
            }
            .font(.callout)
            if (detailed) {
                ForEach(app.events.sorted(by: { $0.updateTime > $1.updateTime })) { event in
                    HStack {
                        Text(event.type.description)
                        Spacer()
                        Text(event.updateTime.formatted(.dateTime.day().month().year()))
                    }
                    .font(.footnote)
                }
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
            }
            Divider()
        }
    }
}
