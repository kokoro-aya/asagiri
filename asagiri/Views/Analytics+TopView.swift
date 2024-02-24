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
//  Analytics+TopView.swift
//  asagiri
//
//  Created by irony on 18/12/2023.
//

import SwiftUI
import SwiftData

struct Analytics_TopView: View {
    
    @Query var applications: [Application]
    
    var count: Int {
        applications.count
    }
    
    var appliedCount: Int {
        applications.filter { $0.status > .preparation }.count
    }
    
    var interviewCount: Int {
        applications
            .filter { $0.events.contains(where: { ev in
                switch ev.type {
                case .interview(_): true
                case .phoneScreen: true
                case .technicalTest: true
                default: false
                } })
            }
            .count
    }
    
    var body: some View {
        VStack {
            if applications.count < 5 {
                Text("Add more applications to preview you stats")
            } else {
                ChartWindowView(applications: applications)
                    .frame(height: 480)
            }
            HStack {
                Spacer()
                VStack {
                    Text("\(count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    Text("Apps")
                        .font(.footnote)
                }
                Spacer()
                VStack {
                    Text("\(appliedCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    Text("Applied")
                        .font(.footnote)
                }
                Spacer()
                VStack {
                    Text("\(interviewCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    Text("Interviews")
                        .font(.footnote)
                }
                Spacer()
            }
            .padding([.top], -24)
        }
        .padding(8)
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        prepareDummyApplicationDataForAnalyticViews(container: &previewContainer)
        
        return Analytics_TopView()
            .modelContainer(previewContainer)
    }
}
