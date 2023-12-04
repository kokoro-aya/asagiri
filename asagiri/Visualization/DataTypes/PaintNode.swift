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
//  PaintNode.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import Foundation

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
