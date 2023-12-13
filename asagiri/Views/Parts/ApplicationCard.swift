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
//  ApplicationCard.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct ApplicationCard: View {
    
    let app: Application
    
    @Environment(\.modelContext) private var modelContext
    
    @State var detailed: Bool = false
    
    @State var updateDate: Date = .now
    
    init(application: Application) {
        self.app = application
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(app.jobDescription?.title ?? "")
                        .font(.headline)
                    Text(app.jobDescription?.organization?.name ?? "")
                        .font(.subheadline)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(app.jobDescription?.type?.name ?? "")
                        .font(.caption)
                        .padding([.trailing], 4)
                    
                    let lastEvent = app.lastEvent
                    
                    if (lastEvent != nil) {
                        let start = app.dateCreated.formatted(.dateTime.day().month().year())
//                        let curr = lastEvent!.updateTime.formatted(.dateTime.day().month().year())
                        
//                        Text("\(start) - \(curr)")
                        Text(" \(start)")
                            .font(.caption)
                            .padding([.trailing], 4)
                            .padding([.bottom], 2)
                    } else {
                        Text(app.dateCreated.formatted(.dateTime.day().month().year()))
                            .font(.caption)
                            .padding([.trailing], 4)
                            .padding([.bottom], 2)
                    }
                    
                    
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
                    NavigationLink(value: app, label: {
                        Text("Detail")
                    })
                }
                Spacer()
                
                let possibleNexts = self.app.status.possibleNexts()
                let canArchive = self.app.status.canArchive()
                
                Menu {
                    ForEach(possibleNexts) { sts in
                        Button(sts.description) {
                            if detailed {
                                self.app.events.append(Event(type: sts, updateTime: updateDate))
                            } else {
                                self.app.events.append(Event(type: sts))
                            }
                        }
                    }
                    if (canArchive) {
                        Divider()
                        Button("Archive", role: .destructive) {
                            self.app.setArchived()
                        }
                    }
                    if (self.app.status == .archived) {
                        Divider()
                        Button("Delete", role: .destructive) {
                            modelContext.delete(self.app)
                        }
                    }
                } label: {
                    Text(app.status.description)
                        .font(.subheadline)
                        .foregroundColor(app.status.color())
                }
                
                Button {
                    if (app.events.count > 0) {
                        detailed = !detailed
                    }
                } label: {
                    if (app.events.count > 0) {
                        Image(systemName: detailed ? "xmark" : "plus")
                            .foregroundColor(app.status.color())
                    } else {
                        Spacer()
                            .frame(width: 25)
                    }
                }
            }
            .padding([.bottom], 2)
            .font(.callout)
            if (detailed) {
                VStack {
                    ForEach(app.events.sorted(by: { $0.updateTime < $1.updateTime })) { event in
                        HStack {
                            Text(event.type.description)
                            Spacer()
                            Text(event.updateTime.formatted(.dateTime.day().month().year()))
                        }
                        .font(.footnote)
                    }
                    
                    DatePicker(selection: $updateDate, in: app.events.sorted(by: { $0.updateTime < $1.updateTime }).last!.updateTime...Date.now, displayedComponents: .date) {
                        Text("Update date")
                            .font(.callout)
                    }
                }
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
            }
            Divider()
                .padding([.top], 2)
                .padding([.bottom], 4)
        }
    }
}
