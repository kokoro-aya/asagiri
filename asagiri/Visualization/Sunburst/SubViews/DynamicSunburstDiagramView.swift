//
//  DynamicSunburstDiagramView.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import SwiftUI
import Charts

struct DynamicSunburstDiagramView: View {
    
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
    
    func computeInnerDetailBound(_ i: Int) -> Int {
        return startingPixel + i * (padding * 2 + width)
    }
    
    func computeOuterDetailBound(_ i: Int) -> Int {
        return computeInnerDetailBound(i) + width
    }
    
    func computeDetailOutbound() -> Int {
        return startingPixel + detailDepth * (padding * 2 + width)
    }
    
    func computeInnerNarrowBound(_ i: Int) -> Int {
        return computeDetailOutbound() + (i - detailDepth) * (padding * 2 + narrowWidth)
    }
    
    func computeOuterNarrowBound(_ i: Int) -> Int {
        return computeDetailOutbound() + (i - detailDepth) * (padding * 2 + narrowWidth) + narrowWidth
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
        hideLegend: false)
}



struct DynamicSunburstDiagramViewDemo: View {
    
    var full: some View {
        ZStack {
            Chart([] as [LabelValuePair], id: \.self) { child in
                SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 1)
                    .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
            }
            .chartForegroundStyleScale(domain: domains, range: chartColors)
            .chartLegend(position: .leading, alignment: .top)
//            .chartLegend(.hidden)
            .padding(16)
            ZStack {
                Chart(generateLabelValuePairs(), id: \.self) { child in
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(62), outerRadius: .fixed(86), angularInset: 1)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel2(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(88), outerRadius: .fixed(112), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel3(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(114), outerRadius: .fixed(138), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel4(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(140), outerRadius: .fixed(144), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel5(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(146), outerRadius: .fixed(150), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 2)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel6(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(152), outerRadius: .fixed(156), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 2)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel7(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(158), outerRadius: .fixed(162), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 2)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel8(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(164), outerRadius: .fixed(168), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 2)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel9(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(186), outerRadius: .fixed(250), angularInset: 1)
                            .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                    } else {
                        SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 2)
                            .foregroundStyle(Color.white)
                    }
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
            }
            .rotationEffect(.degrees(20))
            .scaleEffect(CGSize(width: 1.35, height: 1.35))
        }
      
    }
    
    var body: some View {
        full
    }
}

//#Preview {
//    DynamicSunburstDiagramViewDemo()
//}
