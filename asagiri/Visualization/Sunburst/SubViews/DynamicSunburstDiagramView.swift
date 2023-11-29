//
//  DynamicSunburstDiagramView.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import SwiftUI
import Charts

struct DynamicSunburstDiagramView: View {
    
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

#Preview {
    DynamicSunburstDiagramView()
}
