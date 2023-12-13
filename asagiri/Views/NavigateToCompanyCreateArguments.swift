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
//  NavigateToOrganizationCreateArguments.swift
//  asagiri
//
//  Created by irony on 01/12/2023.
//

import Foundation

struct NavigateToOrganizationCreateArguments : Identifiable, Hashable {
    
    let onCompletion: (Organization) -> ()
    
    // Since it's impossible to hash a closure, we attribute a UUID for each value of this type and refers it for our hash
    var id: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: NavigateToOrganizationCreateArguments, rhs: NavigateToOrganizationCreateArguments) -> Bool {
        return lhs.id == rhs.id
    }
}
