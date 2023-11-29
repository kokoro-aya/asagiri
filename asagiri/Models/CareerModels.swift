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
//  Career.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import Foundation
import SwiftData

@Model
final class CareerType {
    var name: String
    
    var symbol: String?
    
//    var comments: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    // Dummy static value as a placeholder for management list
    static let empty = CareerType(name: "")
}
