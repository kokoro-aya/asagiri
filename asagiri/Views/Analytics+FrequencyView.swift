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
//  Analytics+FrequencyView.swift
//  asagiri
//
//  Created by irony on 18/12/2023.
//

import SwiftUI
import SwiftData
import Charts

struct Analytics_FrequencyView: View {
    
    @Query var applications: [Application]
    
    func processGropingOfAppsPerWeek() -> [(status: ApplicationStatus, data: [LabelValuePair])] {
        let dict =
        Dictionary(grouping: applications, by: { $0.status })
            .map { cat, list in
                (cat, Dictionary(grouping: list, by: {
                    Calendar.current.component(.weekOfYear, from: $0.dateCreated)
                }))
            }
        return dict
            .map { cat, list in
                (status: cat, data: list
                    .map { key, value in
                        LabelValuePair(label: "\(key)", value: value.count)
                    }
                )
        }
    }
    
    func computeDomains(dataset: [(status: ApplicationStatus, data: [LabelValuePair])]) -> [String] {
        return dataset.map { $0.status.description }.sorted()
    }
    
    func findEdges(dataset: [(status: ApplicationStatus, data: [LabelValuePair])]) -> (Int, Int) {
        let allPairs = dataset.flatMap { $0.data }.map { Int($0.label)! }
        let min = allPairs.min()!
        let max = allPairs.max()!
        
        let current = Calendar.current.component(.weekOfYear, from: Date.now)
        
        // This year only or reviewing last year
        if current >= max || current < min {
            return (min, max)
        } else {
            
            // Only display this year
            return (min, current)
        }
    }
    
    var body: some View {
        
        let data = processGropingOfAppsPerWeek()
        
        let edges = findEdges(dataset: data)
        
        
        VStack(alignment: .leading) {
            Text("Applications per week")
                .font(.title3)
                .padding([.bottom], 16)
            Chart {
                ForEach(data, id: \.status) { cat, list in
                    ForEach(list) {
                        BarMark(x: .value($0.label, Int($0.label)!),
                                y: .value("Value", $0.value)
                        )
                    }
                    .foregroundStyle(by: .value("Status(type)", cat.description))
                }
            }
            .chartXScale(domain: [0, 53])
            .chartYAxis(.hidden)
            .chartForegroundStyleScale(domain: computeDomains(dataset: data), range: chartColors)
            .chartLegend(.hidden)
            .frame(height: 180)
        }
        .padding(16)
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        prepareDummyApplicationDataForAnalyticViews(container: &previewContainer)
        
        return Analytics_FrequencyView()
            .modelContainer(previewContainer)
    }
}
