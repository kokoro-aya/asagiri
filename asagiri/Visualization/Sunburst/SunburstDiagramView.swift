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

protocol SunburstPaintSourceProtocol {
    
    var label: String { get set }
    
    func count(label: String) -> Int
    
    func count() -> Int
}
//
class SunburstPaintSourceClass : Hashable {
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: SunburstPaintSourceClass, rhs: SunburstPaintSourceClass) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}

typealias SunburstPaintSource = SunburstPaintSourceClass & SunburstPaintSourceProtocol


final class SunburstPaintEdge : SunburstPaintSource {

    init(label: String, value: Int) {
        self.label = label
        self.value = value
    }
    
    var label: String
    var value: Int
    
    static func == (lhs: SunburstPaintEdge, rhs: SunburstPaintEdge) -> Bool {
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

final class SunburstPaintNode : SunburstPaintSource {
    
    init(label: String, children: [ SunburstPaintSource]) {
        self.label = label
        self.children = children
    }
    
    convenience init(label: String) {
        self.init(label: label, children: [])
    }
    
    var label: String
    var children: [ SunburstPaintSource]
    
    static func == (lhs: SunburstPaintNode, rhs: SunburstPaintNode) -> Bool {
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

let dataSource: SunburstPaintNode = SunburstPaintNode(label: "Submitted",
      children: [
        SunburstPaintNode(label: "Phone Screen", children: [
            SunburstPaintNode(label: "Technical Test", children: [
                    SunburstPaintNode(label: "1st Interview", children: [
                        SunburstPaintNode(label: "2nd Interview", children: [
                                SunburstPaintEdge(label: "Rejected", value: 1),
                                SunburstPaintEdge(label: "Ghosted", value: 3),
                                SunburstPaintEdge(label: "Accepted", value: 1),
                        ]),
                        SunburstPaintEdge(label: "Rejected", value: 2),
                        SunburstPaintEdge(label: "Ghosted", value: 3),
                        SunburstPaintEdge(label: "Accepted", value: 1)
                    ]),
                    SunburstPaintEdge(label: "Rejected", value: 9),
                    SunburstPaintEdge(label: "Ghosted", value: 12)
            ]),
            SunburstPaintEdge(label: "Rejected", value: 17),
            SunburstPaintEdge(label: "Ghosted", value: 26)
        ]),
        SunburstPaintNode(label: "OA", children: [
            SunburstPaintNode(label: "Phone Screen", children: [
                    SunburstPaintNode(label: "1st Interview", children: [
                        SunburstPaintNode(label: "2nd Interview", children: [
                                SunburstPaintNode(label: "3rd Interview", children: [
                                    SunburstPaintNode(label: "4th Interview", children: [
                                        SunburstPaintEdge(label: "Rejected", value: 1)
                                    ]),
                                    SunburstPaintEdge(label: "Rejected", value: 1),
                                    SunburstPaintEdge(label: "Ghosted", value: 2)
                                ]),
                                SunburstPaintEdge(label: "Rejected", value: 2),
                                SunburstPaintEdge(label: "Ghosted", value: 3),
                                SunburstPaintEdge(label: "Accepted", value: 1),
                        ]),
                        SunburstPaintEdge(label: "Rejected", value: 1),
                        SunburstPaintEdge(label: "Ghosted", value: 1)
                    ]),
                    SunburstPaintEdge(label: "Rejected", value: 7),
                    SunburstPaintEdge(label: "Ghosted", value: 6)
            ]),
            SunburstPaintEdge(label: "Rejected", value: 7),
            SunburstPaintEdge(label: "Ghosted", value: 6)
        ]),
        SunburstPaintEdge(label: "Rejected", value: 13),
        SunburstPaintEdge(label: "Ghosted", value: 19)
    ])

struct LabelValuePair : Hashable {
    let label: String
    let value: Int
}

struct SunburstDiagramView: View {
    
    @State private var source: SunburstPaintNode = dataSource
    
    func generateLabelValuePairs() -> [LabelValuePair] {
        return source.children.map { .init(label: $0.label, value: $0.count()) }
    }
    
    func generateLabelValuePairsLevel2() -> [LabelValuePair] {
        let values: [[(String, Int)]] = source.children.map {
            switch $0 {
            case let edge as SunburstPaintEdge:
                [("NA", edge.value)]
            case let node as SunburstPaintNode:
                node.children.map { ($0.label, $0.count()) }
            default:
                []
            }
        }
        
        return values
            .flatMap { $0 }
            .map { (l, v) in
                    .init(label: l, value: v)
            }
    }
    
    func generate1(values: [[(String, Int)]]) -> [LabelValuePair] {
        return values.flatMap { $0 }.map { (l, v) in .init(label: l, value: v) }
    }
    
    var body: some View {
        ZStack {
            Chart(generateLabelValuePairs(), id: \.self) { child in
                SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(96), outerRadius: .fixed(128), angularInset: 4)
                    .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
            }
            .padding([.top], 17.5)
            Chart(generateLabelValuePairsLevel2(), id: \.self) { child in
                if (child.label != "NA") {
                    SectorMark(angle: .value(Text(verbatim: child.label), child.value), innerRadius: .fixed(136), outerRadius: .fixed(160), angularInset: 4)
                        .foregroundStyle(by: .value(Text(verbatim: child.label), child.label))
                } else {
                    SectorMark(angle: .value(Text(verbatim: ""), child.value), innerRadius: .fixed(0), outerRadius: .fixed(0), angularInset: 4)
                        .foregroundStyle(Color.white)
                }
            }
            .chartLegend(.hidden)
        }
      
    }
}


#Preview {
    SunburstDiagramView()
}
