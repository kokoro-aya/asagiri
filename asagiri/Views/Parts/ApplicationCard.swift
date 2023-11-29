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
                    Text(app.jobDescription?.title ?? "")
                        .font(.headline)
                    Text(app.jobDescription?.company?.name ?? "")
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
                
                if (detailed) {
                    let label = switch app.status {
                        case .not_started: "NSTA"
                        case .preparation: "PREP"
                        case .applied: "APPL"
                        case .phone_screen: "PSCR"
                        case .interview(let round): "INT\(round)"
                        case .rejected: "REJ"
                        case .offer: "OFFR"
                        case .ghost: "GHO"
                    }
                    Text(label)
                    
                } else {
                    let possibleNexts = self.app.status.possibleNexts()
                    
                    Menu {
                        ForEach(possibleNexts) { sts in
                            Button(sts.description) {
                                self.app.events.append(Event(type: sts))
                            }
                        }
                    } label: {
                        Text(app.status.description)
                            .font(.subheadline)
                            .foregroundColor(app.status.color())
                    }
                }
                
                Button {
                    if (app.events.count > 0) {
                        detailed = !detailed
                    }
                } label: {
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
