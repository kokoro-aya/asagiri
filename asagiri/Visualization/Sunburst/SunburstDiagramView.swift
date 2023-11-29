//
//  SunburstDiagramView.swift
//  asagiri
//
//  Created by irony on 28/11/2023.
//

import SwiftUI
import Charts

// https://stackoverflow.com/questions/24111356/swift-class-method-which-must-be-overridden-by-subclass

// https://stackoverflow.com/questions/68893073/does-not-conform-to-protocol-hashable

//

func generateLabelValuePairs(data: [PaintEdge]) -> [LabelValuePair] {
    return data.map {
        .init(label: $0.label, value: $0.value)
    }
}

func generateLabelValuePairsFromPossiblyEmptyEdges(data: [CouldBeEmptyEdge]) -> [LabelValuePair] {
    return data.map {
        switch $0 {
        case let e as PaintEdge: .init(label: e.label, value: e.value)
        case let e as EmptyPart: .init(label: "NA", value: e.length)
        default:
            fatalError("Unknown type other than PaintEdge and EmptyPart")
        }
    }
}

func generateLabelValuePairs() -> [LabelValuePair] {
    return dataSource.children.map { .init(label: $0.label, value: $0.count()) }
}

func generateLabelValuePairsLevel2() -> [LabelValuePair] {
    
    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 1, falldown: false))
}

func generateLabelValuePairsLevel3() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 2, falldown: false))
}

func generateLabelValuePairsLevel4() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 3, falldown: false))
}

func generateLabelValuePairsLevel5() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 4, falldown: false))
}

func generateLabelValuePairsLevel6() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 5, falldown: false))
    
}

func generateLabelValuePairsLevel7() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 6, falldown: false))
}

func generateLabelValuePairsLevel8() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 7, falldown: false))
}

func generateLabelValuePairsLevel9() -> [LabelValuePair] {

    return asagiri.generateLabelValuePairsFromPossiblyEmptyEdges(data: dataSource.partlyMaskedTraverse(maskLevel: 8, falldown: false))
}

func generate1(values: [[(String, Int)]]) -> [LabelValuePair] {
//        return values.flatMap { $0 }.map { (l, v) in .init(label: l, value: v) }
    return asagiri.generateLabelValuePairs(data: dataSource.simpleTraverse())
}

struct SunburstDiagramView: View {
    
    var body: some View {
        full2
    }
    
    var full1: some View {
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
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(62), outerRadius: .fixed(76), angularInset: 1)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                }
                .chartForegroundStyleScale(domain: domains, range: chartColors)
                .chartLegend(.hidden)
                Chart(generateLabelValuePairsLevel2(), id: \.self) { child in
                    if (child.label != "NA") {
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(78), outerRadius: .fixed(92), angularInset: 1)
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
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(94), outerRadius: .fixed(106), angularInset: 1)
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
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(108), outerRadius: .fixed(122), angularInset: 1)
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
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(124), outerRadius: .fixed(138), angularInset: 1)
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
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(140), outerRadius: .fixed(154), angularInset: 1)
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
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(156), outerRadius: .fixed(168), angularInset: 1)
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
                        SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(170), outerRadius: .fixed(184), angularInset: 1)
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
    
    var full2: some View {
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
}

#Preview {
    SunburstDiagramView()
}
