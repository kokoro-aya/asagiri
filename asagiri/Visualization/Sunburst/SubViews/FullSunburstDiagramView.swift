//
//  FullSunburstDiagramView.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import SwiftUI
import Charts

struct FullSunburstDiagramView: View {
    
    @State var dataSource: PaintNode
    
    @State var domains: [String]
    
    @State var chartColors: [Color]
    
    let disappearDepth: Int // 7
    
    let startingPixel: Int
    
    let width: Int
    
    let padding: Int
    
    let hideLegend: Bool
    
    func generateLabelValuePairs(level: Int) -> [LabelValuePair] {
        return if level <= 0 {
            asagiri.generateLabelValuePairs(data: dataSource.simpleTraverse())
        } else {
            asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: level, falldown: false))
        }
    }
    
    func computeInnerDetailBound(_ i: Int) -> Int {
        return startingPixel + i * (padding * 2 + width)
    }
    
    func computeOuterDetailBound(_ i: Int) -> Int {
        return computeInnerDetailBound(i) + width
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
            
            ForEach(0 ..< disappearDepth) { i in
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
        }
    }
}

#Preview {
    FullSunburstDiagramView(
        dataSource: dataSource,
        domains: domains, chartColors: chartColors,
        disappearDepth: 7,
        startingPixel: 62, width: 24, padding: 2,
        hideLegend: true)
}