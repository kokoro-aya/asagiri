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

protocol CouldBeEmptyEdge { }

protocol PaintSourceProtocol {
    
    var label: String { get set }
    
    func simpleTraverse() -> [PaintEdge]
    
    func traverse() -> [PaintEdge]
    
    func partlyMaskedTraverse(maskLevel level: Int, falldown: Bool) -> [CouldBeEmptyEdge]
    
    
    func count(label: String) -> Int
    
    func count() -> Int
}

final class EmptyPart : CouldBeEmptyEdge {
    
    var length: Int
    
    init(length: Int) {
        self.length = length
    }
}

class PaintSourceClass : Hashable {
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: PaintSourceClass, rhs: PaintSourceClass) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}

typealias PaintSource = PaintSourceClass & PaintSourceProtocol


final class PaintEdge : PaintSource, CouldBeEmptyEdge {

    init(label: String, value: Int) {
        self.label = label
        self.value = value
    }
    
    var label: String
    var value: Int
    
    
    func simpleTraverse() -> [PaintEdge] {
        return [self]
    }
    
    func traverse() -> [PaintEdge] {
        return [self]
    }
    
    func partlyMaskedTraverse(maskLevel level: Int, falldown: Bool) -> [CouldBeEmptyEdge] {
        return if level <= 0 {
            [self]
        } else {
            [EmptyPart(length: self.value)]
        }
    }
    
    
    static func == (lhs: PaintEdge, rhs: PaintEdge) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    override func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    func count(label: String) -> Int {
        if label == self.label {
            return self.value
        } else {
            return 0
        }
    }
    
    func count() -> Int {
        return self.value
    }
    
}

final class PaintNode : PaintSource {

    
    
    init(label: String, children: [ PaintSource]) {
        self.label = label
        self.children = children
    }
    
    convenience init(label: String) {
        self.init(label: label, children: [])
    }
    
    var label: String
    var children: [ PaintSource]
    
    func simpleTraverse() -> [PaintEdge] {
        return self.children
            .flatMap { child in
                switch child {
                case _ as PaintEdge: child.simpleTraverse()
                case let n as PaintNode: [PaintEdge(label: n.label, value: n.count())]
                default:
                    [] as [PaintEdge]
                }
            }
    }
    
    func traverse() -> [PaintEdge] {
        return self.children
            .flatMap { child in
                switch child {
                case let e as PaintEdge: [e]
                case let n as PaintNode: n.traverse()
                default:
                    [] as [PaintEdge]
                    // Otherwise "Type 'Void' cannot conform to 'Sequence'"
                }
            }
    }
    
    func partlyMaskedTraverse(maskLevel level: Int, falldown: Bool) -> [CouldBeEmptyEdge] {
        if (level <= 0) {
            return if falldown {
                self.traverse() as [CouldBeEmptyEdge]
            } else {
                self.simpleTraverse() as [CouldBeEmptyEdge]
            }
        } else {
            return self.children
                .flatMap { child in
                    switch child {
                    case let e as PaintEdge: [EmptyPart(length: e.value)] as [CouldBeEmptyEdge]
                    case let n as PaintNode: n.partlyMaskedTraverse(maskLevel: level - 1, falldown: falldown) as [CouldBeEmptyEdge]
                        // Will report error as type is not string if miss an argument
                    default:
                        [] as [CouldBeEmptyEdge]
                    }
                }
        }
    }
    
//    func partlyMaskedTraverse(maskLevel level: Int, falldown: Bool) -> [CouldBeEmptyEdge] {
//        return if (level <= 0) {
//            if falldown {
//                self.traverse() as [CouldBeEmptyEdge]
//            } else {
//                self.simpleTraverse() as [CouldBeEmptyEdge]
//            }
//        } else {
//            self.children
//                .flatMap {
//                    switch $0 {
//                    case let e as PaintEdge: [EmptyPart(length: e.value)] as [CouldBeEmptyEdge]
//                    case let n as PaintNode: n.partlyMaskedTraverse(maskLevel: level - 1) as [CouldBeEmptyEdge]
//                    default:
//                        [] as [CouldBeEmptyEdge]
//                    }
//                }
//        }
//    }
    
    static func == (lhs: PaintNode, rhs: PaintNode) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    override func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
    
    func count(label: String) -> Int {
        return children.map { $0.count(label: label) }.reduce(0, +)
    }
    
    func count() -> Int {
        return children.map { $0.count() }.reduce(0, +)
    }
}

let dataSource: PaintNode = PaintNode(label: "Submitted",
      children: [
        PaintNode(label: "Phone Screen", children: [
            PaintNode(label: "Technical Test", children: [
                    PaintNode(label: "1st Interview", children: [
                        PaintNode(label: "2nd Interview", children: [
                                PaintEdge(label: "Rejected", value: 1),
                                PaintEdge(label: "Ghosted", value: 3),
                                PaintEdge(label: "Accepted", value: 1),
                        ]),
                        PaintEdge(label: "Rejected", value: 2),
                        PaintEdge(label: "Ghosted", value: 3),
                        PaintEdge(label: "Accepted", value: 1)
                    ]),
                    PaintEdge(label: "Rejected", value: 9),
                    PaintEdge(label: "Ghosted", value: 12)
            ]),
            PaintEdge(label: "Rejected", value: 17),
            PaintEdge(label: "Ghosted", value: 26)
        ]),
        PaintNode(label: "OA", children: [
            PaintNode(label: "Phone Screen", children: [
                    PaintNode(label: "1st Interview", children: [
                        PaintNode(label: "2nd Interview", children: [
                                PaintNode(label: "3rd Interview", children: [
                                    PaintNode(label: "4th Interview", children: [
                                        PaintEdge(label: "Rejected", value: 1)
                                    ]),
                                    PaintEdge(label: "Rejected", value: 1),
                                    PaintEdge(label: "Ghosted", value: 2)
                                ]),
                                PaintEdge(label: "Rejected", value: 2),
                                PaintEdge(label: "Ghosted", value: 3),
                                PaintEdge(label: "Accepted", value: 1),
                        ]),
                        PaintEdge(label: "Rejected", value: 1),
                        PaintEdge(label: "Ghosted", value: 1)
                    ]),
                    PaintEdge(label: "Rejected", value: 7),
                    PaintEdge(label: "Ghosted", value: 6)
            ]),
            PaintEdge(label: "Rejected", value: 7),
            PaintEdge(label: "Ghosted", value: 6)
        ]),
        PaintEdge(label: "Rejected", value: 13),
        PaintEdge(label: "Ghosted", value: 19)
    ])

struct LabelValuePair : Hashable {
    let label: String
    let value: Int
    
    let id: String
    
    init(label: String, value: Int) {
        self.label = label
        self.value = value
        self.id = UUID().uuidString
    }
}

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

struct SunburstDiagramView: View {
    
    @State private var source: PaintNode = dataSource
    
    func generateLabelValuePairs() -> [LabelValuePair] {
        return source.children.map { .init(label: $0.label, value: $0.count()) }
    }
    
    func generateLabelValuePairsLevel2() -> [LabelValuePair] {
//        let values: [[(String, Int)]] = source.children.map {
//            switch $0 {
//            case let edge as PaintEdge:
//                [("NA", edge.value)]
//            case let node as PaintNode:
//                node.children.map { ($0.label, $0.count()) }
//            default:
//                []
//            }
//        }
//        
//        return values
//            .flatMap { $0 }
//            .map { (l, v) in
//                    .init(label: l, value: v)
//            }
        
//        let data = dataSource.partlyMaskedTraverse(maskLevel: 1, falldown: false)
//        data.forEach {
//            switch $0 {
//                case let e as PaintEdge: print(e.label)
//                case let _ as EmptyPart: print("EA")
//                default: break
//            }
//        }
//        
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
    
    func generate1(values: [[(String, Int)]]) -> [LabelValuePair] {
//        return values.flatMap { $0 }.map { (l, v) in .init(label: l, value: v) }
        return asagiri.generateLabelValuePairs(data: dataSource.simpleTraverse())
    }
    
    var body: some View {
        ZStack {
            Chart(generateLabelValuePairs(), id: \.self) { child in
                SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(48), outerRadius: .fixed(76), angularInset: 2)
                    .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
            }
            .chartLegend(.hidden)
            Chart(generateLabelValuePairsLevel2(), id: \.self) { child in
                if (child.label != "NA") {
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(80), outerRadius: .fixed(108), angularInset: 2)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                } else {
                    SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                        .foregroundStyle(Color.white)
                }
            }
            .chartLegend(.hidden)
            Chart(generateLabelValuePairsLevel3(), id: \.self) { child in
                if (child.label != "NA") {
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(112), outerRadius: .fixed(140), angularInset: 2)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                } else {
                    SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                        .foregroundStyle(Color.white)
                }
            }
            .chartLegend(.hidden)
            Chart(generateLabelValuePairsLevel4(), id: \.self) { child in
                if (child.label != "NA") {
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(144), outerRadius: .fixed(168), angularInset: 2)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                } else {
                    SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                        .foregroundStyle(Color.white)
                }
            }
            .chartLegend(.hidden)
            Chart(generateLabelValuePairsLevel5(), id: \.self) { child in
                if (child.label != "NA") {
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(172), outerRadius: .fixed(196), angularInset: 2)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                } else {
                    SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 2)
                        .foregroundStyle(Color.white)
                }
            }
            .chartLegend(.hidden)
        }
        .rotationEffect(.degrees(20))
      
    }
}


#Preview {
    SunburstDiagramView()
}
