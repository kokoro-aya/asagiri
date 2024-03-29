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
    
    @Binding var option: ApplicationSortOption
    
    let onDelete: (ApplicationSortOption) -> ()
    
    var body: some View {
        HStack {
            Button {
                option.direction = !option.direction
            } label: {
                if option.direction == .ascending {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.gray)
                }
            }
            Text(option.type.description)
                .font(.callout)
                .foregroundColor(.gray)
            Button {
                onDelete(option)
            } label: {
                Image(systemName: "multiply")
                    .foregroundColor(.gray)
                    .frame(width: 12, height: 12)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16))
        .foregroundColor(.gray.opacity(0.15))
    }
}

#Preview {
    
    let option = ApplicationSortOption(type: .byCreationDate, direction: .ascending)
    
    return TagChip(option: .constant(option), onDelete: { _ in })
}

