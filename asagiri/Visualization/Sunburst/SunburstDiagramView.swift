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
    return asagiri.generateLabelValuePairs(data: dataSource.simpleTraverse())
//    return dataSource.children.map { .init(label: $0.label, value: $0.count()) }
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
        Text("Placeholder")
    }
    
}

#Preview {
    SunburstDiagramView()
}
