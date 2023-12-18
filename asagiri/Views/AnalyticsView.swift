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
//  AnalyticsView.swift
//  asagiri
//
//  Created by irony on 04/12/2023.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {

    @Binding var pathManager:PathManager

    @State private var displayMenuBar: Bool = false
    
    var body: some View {
        ScrollView {
            Analytics_TopView()
            Divider()
            Analytics_GoalView()
        }
        .padding(16)
        .toolbar {
            if displayMenuBar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = false
                    } label: {
                        Label("Menu", systemImage: "arrow.left")
                    }
                    
                    NavigationLink(value: PageType.home, label: {
                        Label("Home", systemImage: "house.fill")
                    })
                    
                    NavigationLink(value: PageType.jd_list, label: {
                        Label("JD List", systemImage: "bag.fill")
                    })
                    
                    NavigationLink(value: PageType.settings, label: {
                        Label("Settings", systemImage: "gear")
                    })
                    
                    Label("Analytics", systemImage: "chart.pie")
                        .foregroundColor(.black)
                        .padding([.leading], 10)
                }
            } else {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = true
                    } label: {
                        Label("Menu", systemImage: "line.3.horizontal")
                    }
                    
                    Text("Analytics")
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        prepareDummyApplicationDataForAnalyticViews(container: &previewContainer)
        
        return AnalyticsView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
