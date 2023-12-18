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
//  ChartWindowView.swift
//  asagiri
//
//  Created by irony on 02/12/2023.
//

import SwiftUI
import SwiftData

struct ChartWindowView: View {
    
    let dataSource: PaintNode
    
    let _domains: [String]
    
    var domains: [String] {
        return _domains.sorted()
    }
    
    let maxInterviewRound: Int
    
    init(applications: [Application]) {
        self.dataSource = preparePaintNodes(apps: applications)
        self.maxInterviewRound = computeMaxInterviewRound(apps: applications)
        var domains = collectDistinctNamesFrom(names: collectNamesFrom(node: dataSource))
        if let submittedPos = domains.firstIndex(of: "Submitted") {
            domains.remove(at: submittedPos)
        }
        self._domains = domains
    }
    
    let chartColors: [Color] = [
        Color(hex: 0x00aa90),
        Color(hex: 0xe98b2a),
        Color(hex: 0xd0104c),
        Color(hex: 0x91ad70),
        Color(hex: 0xb28fce),
        Color(hex: 0xe16b8c),
        Color(hex: 0xfc9f4d),
        Color(hex: 0x5b622e),
        Color(hex: 0x33a6b8),
        Color(hex: 0x0c4842),
    ]

    
    var body: some View {
        StaticDetailAbstractDiagramView(
            dataSource: dataSource,
            domains: domains,
            excludeInLegend: ["Pending"],
            chartColors: chartColors,
            detailDepth: 3,
            disappearDepth: 10,
            startingPixel: 62,
            width: 24,
            narrowWidth: 4,
            padding: 2,
            hideLegend: false)
    }
}

func collectDistinctNamesFrom(names: [String]) -> [String] {
    return Array(Set(names))
}

func collectNamesFrom(node: any PaintSource) -> [String] {
    switch node {
    case let n as PaintNode:
        var names = n.children.flatMap {
            collectNamesFrom(node: $0)
        }
        names.append(n.label)
        return names
    case let e as PaintEdge:
        return [e.label]
    default:
        return [] as [String] // should properly handled by raise an error
    }
}

func findOrCreatePaintNode(node current: PaintNode, label: String) -> PaintNode {
    if let target = current.children.first(where: { $0.label == label }) as? PaintNode {
        return target
    } else {
        let node = PaintNode(label: label)
        current.children.append(node)
        return node
    }
}

func insertOrCreatePaintEdge(node current: PaintNode, label: String) {
    if let target = current.children.first(where: { $0.label == label }) as? PaintEdge {
        target.value += 1
    } else {
        let node = PaintEdge(label: label, value: 1)
        current.children.append(node)
    }
}

func insertEventInto(paintNode node: PaintNode, events: [Event]) {
    if events.isEmpty {
        insertOrCreatePaintEdge(node: node, label: "Pending")
    } else {
        switch events.first!.type {
        case .notStarted:
            var nextNode = findOrCreatePaintNode(node: node, label: "Not Started")
            insertEventInto(paintNode: nextNode, events: Array(events.dropFirst()))
        case .preparation:
            // Remove the `preparation` node since it's everywhere
            insertEventInto(paintNode: node, events: Array(events.dropFirst()))
        case .applied:
            var nextNode = findOrCreatePaintNode(node: node, label: "Applied")
            insertEventInto(paintNode: nextNode, events: Array(events.dropFirst()))
        case .oa:
            var nextNode = findOrCreatePaintNode(node: node, label: "OA")
            insertEventInto(paintNode: nextNode, events: Array(events.dropFirst()))
        case .phoneScreen:
            var nextNode = findOrCreatePaintNode(node: node, label: "Phone Screen")
            insertEventInto(paintNode: nextNode, events: Array(events.dropFirst()))
        case .technicalTest:
            var nextNode = findOrCreatePaintNode(node: node, label: "Technical Test")
            insertEventInto(paintNode: nextNode, events: Array(events.dropFirst()))
        case .interview(let round):
            var nextNode = findOrCreatePaintNode(node: node, label: "Interview \(round)")
            insertEventInto(paintNode: nextNode, events: Array(events.dropFirst()))
        case .rejected:
            insertOrCreatePaintEdge(node: node, label: "Rejected")
        case .offer:
            insertOrCreatePaintEdge(node: node, label: "Offer")
        case .ghost:
            insertOrCreatePaintEdge(node: node, label: "Ghosted")
        case .archived:
            insertOrCreatePaintEdge(node: node, label: "Archived")
        }
    }
}

func preparePaintNodes(apps: [Application]) -> PaintNode {
    var node = PaintNode(label: "Submitted")
    
    apps.forEach {
        
        // Swift arrays are not thread safe, orders could be rearranged so we need to sort them before processing
        let sortedEvents = $0.events.sorted(by: { left, right in
            left.updateTime < right.updateTime
        })
        insertEventInto(paintNode: node, events: sortedEvents)
    }
    
    return node
}

func computeMaxInterviewRound(apps: [Application]) -> Int {
    return apps
        .flatMap { $0.events }
        .map {
            switch $0.type {
            case .interview(let round): round
            default: 0
            }
        }
        .max() ?? 0

}

// There is an issue with the preview as data below is not stable to be rendered, seems like there are some concurrency issues related to the tree creation

// The same dataset should work in live simulator but I am not sure
#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let applications = [
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .preparation, updateTime: createDateFromString("2023-10-11T12:00:00-08:00")),
                Event(type: .applied, updateTime: createDateFromString("2023-10-12T12:00:00-08:00")),
                Event(type: .rejected, updateTime: createDateFromString("2023-10-13T14:50:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .preparation, updateTime: createDateFromString("2023-10-10T12:00:00-08:00")),
                Event(type: .applied, updateTime: createDateFromString("2023-10-11T12:00:00-08:00")),
                Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-12T21:00:00-08:00")),
                Event(type: .interview(round: 2), updateTime: createDateFromString("2023-10-16T15:20:00-08:00")),
                Event(type: .interview(round: 3), updateTime: createDateFromString("2023-10-19T14:00:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .preparation, updateTime: createDateFromString("2023-10-11T12:00:00-08:00")),
                Event(type: .applied, updateTime: createDateFromString("2023-10-17T12:00:00-08:00")),
                Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-18T14:30:00-08:00")),
                Event(type: .ghost, updateTime: createDateFromString("2023-10-22T14:20:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .preparation, updateTime: createDateFromString("2023-10-10T12:00:00-08:00")),
                Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00"))
            ])
        ]
        
        applications.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return ChartWindowView(applications: applications)
            .modelContainer(previewContainer)
    }
}
