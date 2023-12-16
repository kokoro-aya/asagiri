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
//  TagChip.swift
//  asagiri
//
//  Created by irony on 16/12/2023.
//

import SwiftUI

struct TagChip: View {
    let text: String
    
    let onDelete: (any Hashable) -> ()
    
    var body: some View {
        HStack {
            Text(text)
                .font(.callout)
                .foregroundColor(.gray)
            Button {
                onDelete(text)
            } label: {
                Image(systemName: "multiply")
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 12)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16))
        .foregroundColor(.gray.opacity(0.15))
    }
}

#Preview {
    TagChip(text: "Hello", onDelete: { _ in })
}

