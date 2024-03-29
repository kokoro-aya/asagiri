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
//  DynamicSunburstDiagramView.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import SwiftUI
import Charts

struct DynamicSunburstDiagramView: View, DynamicSunburstSubView {
    
    @State var dataSource: PaintNode
    
    var top: PaintNode
    
    @State var domains: [String]
    
    @State var chartColors: [Color]
    
    @State var currentLevel: Int
    
    let detailDepth: Int // 3
    
    let disappearDepth: Int // 7
    
    let startingPixel: Int
    
    let width: Int
    
    let narrowWidth: Int
    
    let padding: Int
    
    let hideLegend: Bool
    
    func generateLabelValuePairs(level: Int) -> [LabelValuePair] {
        return if level <= 0 {
            asagiri.generateLabelValuePairs(data: top.simpleTraverse())
        } else {
            asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: top.partlyMaskedTraverse(maskLevel: level, falldown: false))
        }
    }
    

    
    
    var body: some View {
        ZStack {
            Chart([] as [LabelValuePair], id: \.self) { child in
                SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 1)
                    .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
            }
            .chartForegroundStyleScale(domain: domains, range: chartColors)
            .chartLegend(position: .leading, alignment: .top)
            .chartLegend(hideLegend ? .hidden : .visible)
            .padding(16)
            
            ForEach(0 ..< detailDepth) { i in
                Chart(generateLabelValuePairs(level: i), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(
                            angle: .value(Text(verbatim: child.label), child.value),
                            innerRadius: .fixed(CGFloat(computeInnerDetailBound(i))),
                            outerRadius: .fixed(CGFloat(computeOuterDetailBound(i))),
                            angularInset: CGFloat(padding))
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(
                            angle: .value(Text(verbatim: ""), child.value),
                            innerRadius: .fixed(0),
                            outerRadius: .fixed(0),
                            angularInset: 0)
                        .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
            }
            ForEach(detailDepth ..< disappearDepth) { i in
                Chart(generateLabelValuePairs(level: i), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(
                            angle: .value(Text(verbatim: child.label), child.value),
                            innerRadius: .fixed(CGFloat(computeInnerNarrowBound(i))),
                            outerRadius: .fixed(CGFloat(computeOuterNarrowBound(i))),
                            angularInset: CGFloat(padding))
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(
                            angle: .value(Text(verbatim: ""), child.value),
                            innerRadius: .fixed(0),
                            outerRadius: .fixed(0),
                            angularInset: 0)
                        .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
            }
        }
    }
    
}

#Preview {
    DynamicSunburstDiagramView(
        dataSource: dataSource, top: dataSource,
        domains: domains, chartColors: chartColors,
        currentLevel: 0, detailDepth: 3, disappearDepth: 7,
        startingPixel: 62, width: 24, narrowWidth: 4, padding: 2,
        hideLegend: true)
}

