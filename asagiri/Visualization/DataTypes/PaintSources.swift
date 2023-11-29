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
//  PaintSources.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import Foundation

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
