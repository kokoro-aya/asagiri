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
//  Sunburst+Subviews+Protocols.swift
//  asagiri
//
//  Created by irony on 01/12/2023.
//

import Foundation

protocol SankeySubView {
    var startingPixel: Int { get }
    
    var padding: Int { get }
    
    var width: Int { get }
    
}

protocol DynamicSankeySubView : SankeySubView {
    
    var narrowWidth: Int { get }
    
    var detailDepth: Int { get }
}

extension SankeySubView {
    func computeInnerDetailBound(_ i: Int) -> Int {
        return startingPixel + i * (padding * 2 + width)
    }

    func computeOuterDetailBound(_ i: Int) -> Int {
        return computeInnerDetailBound(i) + width
    }
}

extension DynamicSankeySubView {
    
    func computeDetailOutbound() -> Int {
        return startingPixel + detailDepth * (padding * 2 + width)
    }
    
    func computeInnerNarrowBound(_ i: Int) -> Int {
        return computeDetailOutbound() + (i - detailDepth) * (padding * 2 + narrowWidth)
    }

    func computeOuterNarrowBound(_ i: Int) -> Int {
        return computeDetailOutbound() + (i - detailDepth) * (padding * 2 + narrowWidth) + narrowWidth
    }
}

