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
//  Analytics+FullScreen+GoalView.swift
//  asagiri
//
//  Created by irony on 18/12/2023.
//

import SwiftUI
import SwiftData
import Charts

struct Analytics_FullScreen_GoalView: View {
    
    @Query var applications: [Application]
    
    var appliedThisMonth: Int {
        return applications.filter { $0.dateCreated >= monthStarts }.count
    }
    
    var goal: Int {
        if appliedThisMonth < 30 {
            return 30
        } else if appliedThisMonth < 60 {
            return 60
        } else if appliedThisMonth < 90 {
            return 90
        } else {
            return appliedThisMonth
        }
    }
    
    func dateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let begins = formatter.string(from: monthStarts)
        let curr = formatter.string(from: .now)
        return "\(begins) - \(curr)"
    }
    
    var data: [(name: String, count: Int)] {
        return [
            (name: "Applied", count: appliedThisMonth),
            (name: "Unfinished", count: goal - appliedThisMonth)
        ]
    }
    
    let domains = ["Applied", "Unfinished"]
    let chartColors: [Color] = [.blue, .teal.opacity(0.5)]
    
    
    var body: some View {
        VStack {
            Text("This Month")
                .font(.title2)
                .padding([.bottom], 16)
            ZStack {
                Chart {
                    ForEach(data, id: \.name) { data in
                        SectorMark(
                            angle: .value("App", data.count),
                            innerRadius: .ratio(0.8),
                            angularInset: 2.0
                        )
                        .foregroundStyle(by: .value("Type", data.name))
                    }
                }
                .frame(height: 240)
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                
                VStack {
                    Text("\(appliedThisMonth)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    Text("\(goal)")
                        .font(.callout)
                        .foregroundStyle(.teal)
                }
            }
            
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        prepareDummyApplicationDataForAnalyticViews(container: &previewContainer)
        
        return Analytics_FullScreen_GoalView()
            .modelContainer(previewContainer)
        
    }
}
