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
//  TagManageView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI
import SwiftData
import SymbolPicker

enum TagEdit {
    case none, adding, editing
}

struct TagManageView: View {
    
    @State private var displayMenuBar = false
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var tags: [Tag]
    
    @State private var text = ""
    
    @FocusState private var focusedTag: Tag?
    
    @State private var editingTag: Tag?
    
    @State private var editing: TagEdit = .none
    
    var editingList: [Tag] {
        if (editing == .adding) {
            return tags + [Tag.empty]
        } else {
            return tags
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            if (0 ..< tags.count).contains(index) {
                let TagToRemove = tags[index]
                
                // TODO: Implement pre-delete logics to cast every related JD to uncategorized
                
                modelContext.delete(TagToRemove)
            }
        }
    }
    
    var body: some View {
            VStack {
                List {
                    ForEach(editingList) { item in
                        if item == Tag.empty {
                            TextField("New item", text: $text)
                                .focused($focusedTag, equals: item)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.focusedTag = item
                                    }
                                }
                                .onChange(of: focusedTag) { foc in
                                    if (foc != item) {
                                        if (text != "") {
                                            modelContext.insert(Tag(name: text))
                                        }
                                        text = ""
                                        editing = .none
                                    }
                                }
                        } else {
                            if (editing == .editing && editingTag == item) {
                                HStack {
                                    
                                    TextField("Edit item", text: $text) {
                                        
                                    }
                                }
                                .focused($focusedTag, equals: item)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.focusedTag = item
                                    }
                                }
                                .onChange(of: focusedTag) { foc in
                                    if (foc != item) {
                                        if (text != "") {
                                            item.name = text
                                        }
                                        text = ""
                                        editing = .none
                                        editingTag = nil
                                    }
                                }
                            } else {
                                Text(item.name)
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            editingTag = item
                                            editing = .editing
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                    }
                    .onDelete(perform: removeRows)
//                    .listRowBackground(Color.)
                }
//                .scrollContentBackground(.hidden)
                Spacer()
                Button {
                    
                    if (editing == .adding && text.count > 0) {
                        editing = .none
                        self.focusedTag = nil
                    }
                    
                    editing = .adding
                } label: {
                    Label("Add", systemImage: "plus")
                        .padding(12)
                }
            }
            .padding([.top], 20)
            .padding(16)
            .toolbar {
                if displayMenuBar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = false
                        } label: {
                            Label("Menu", systemImage: "arrow.left")
                        }
                        
                        NavigationLink(destination: ApplicationListView(pathManager: $pathManager).navigationBarBackButtonHidden(true), label: {
                            Label("Menu", systemImage: "house.fill")
                        })
                        
                        NavigationLink(destination: SettingsView(pathManager: $pathManager).navigationBarBackButtonHidden(true), label: {
                            Label("Settings", systemImage: "gear")
                        })
                    }
                } else {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = true
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                        
                        Text("Manage Tags")
                            .font(.title2)
                    }
                }
            }
        }
    }
#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let Tags = [
            Tag(name: "bodyshop"),
            Tag(name: "local"),
            Tag(name: "favorites"),
            Tag(name: "babyfoot"),
            Tag(name: "startup nation")
        ]
        
        Tags.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return TagManageView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
