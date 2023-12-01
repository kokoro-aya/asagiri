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
//  CollapseToggle.swift
//  asagiri
//
//  Created by irony on 01/12/2023.
//

import Foundation
import SwiftUI

struct CollapseToggle : View {
    
    @Binding var toggled: Bool
    
    let onPress: () -> ()
    
    var body: some View {
        Button (action: onPress) {
            if (toggled) {
                Image(systemName: "xmark")
            } else {
                Image(systemName: "plus")
            }
        }
        .foregroundColor(.black)
        .padding(8)
    }
}

