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
    
    func processGropingOfAppsPerWeek() -> [LabelValuePair] {
        let dict = Dictionary(grouping: applications, by: {
            Calendar.current.component(.weekOfYear, from: $0.dateCreated)
        })
        return dict.map { key, value in
            LabelValuePair(label: "\(key)", value: value.count)
        }
    }
    
    var body: some View {
        VStack {
            Text("All Applications")
                .font(.title2)
            Chart {
                ForEach(processGropingOfAppsPerWeek()) {
                    BarMark(x: .value($0.label, $0.label),
                            y: .value("Value", $0.value))
                }
            }
            .frame(height: 180)
            .padding(16)
        }
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
