//
//  PaintEdge.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import Foundation

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
