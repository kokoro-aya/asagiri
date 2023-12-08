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
//  DemoSource.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import Foundation
import SwiftUI

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

let sampleDataSource = PaintNode(label: "Submitted", children: [
    PaintNode(label: "Applied", children: [
        PaintEdge(label: "Pending", value: 4)
    ])
])

let domains = ["Phone Screen", "OA", "1st Interview", "2nd Interview", "3rd Interview", "4th Interview", "Technical Test", "Accepted", "Rejected", "Ghosted"]

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
