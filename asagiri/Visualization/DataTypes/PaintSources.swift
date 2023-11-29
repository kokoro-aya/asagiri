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
