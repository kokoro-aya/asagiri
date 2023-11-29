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
//  CareerManageView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI
import SwiftData
import SymbolPicker

enum CareerEdit {
    case none, adding, editing
}

struct CareerManageView: View {
    
    @State private var displayMenuBar = false
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var careerTypes: [CareerType]
    
    @State private var text = ""
    
    @FocusState private var focusedCareer: CareerType?
    
    @State private var editingCareer: CareerType?
    
    @State private var editing: CareerEdit = .none
    
    @State private var iconPlace: String = ""
    
    @State private var iconpicking: Bool = false
    
    var editingList: [CareerType] {
        if (editing == .adding) {
            return careerTypes + [CareerType.empty]
        } else {
            return careerTypes
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            if (0 ..< careerTypes.count).contains(index) {
                let careerToRemove = careerTypes[index]
                
                // TODO: Implement pre-delete logics to cast every related JD to uncategorized
                
                modelContext.delete(careerToRemove)
            }
        }
    }
    
    var body: some View {
            VStack {
                List {
                    ForEach(editingList) { item in
                        if item == CareerType.empty {
                            TextField("New item", text:
                                        $text)
                            .focused($focusedCareer, equals: item)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.focusedCareer = item
                                }
                            }
                            .onChange(of: focusedCareer) { foc in
                                if (foc != item) {
                                    if (text != "") {
                                        modelContext.insert(CareerType(name: text))
                                    }
                                    text = ""
                                    editing = .none
                                }
                            }
                        } else {
                            if (editing == .editing && editingCareer == item) {
                                TextField("Edit item", text: $text) {
                                    
                                }
                                .focused($focusedCareer, equals: item)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.focusedCareer = item
                                    }
                                }
                                .onChange(of: focusedCareer) { foc in
                                    if (foc != item) {
                                        if (text != "") {
                                            item.name = text
                                        }
                                        text = ""
                                        editing = .none
                                        editingCareer = nil
                                    }
                                }
                            } else {
                                HStack {
                                    if (item.symbol != nil) {
                                        Image(systemName: item.symbol!)
                                    }
                                    Text(item.name)
                                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                            Button {
                                                editingCareer = item
                                                editing = .editing
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                            Button {
                                                editingCareer = item
                                                iconpicking = true
                                            } label: {
                                                Label("Icon", systemImage: "info.circle")
                                            }
                                        }
                                        .sheet(isPresented: $iconpicking, onDismiss: {
                                            
                                            // There should be a bug because this function could be called two time for the sheet within an update
                                            if (editingCareer != nil) {
                                                editingCareer!.symbol = iconPlace
                                            }
                                            editingCareer = nil
                                            iconpicking = false
                                        }) {
                                            SymbolPicker(symbol: $iconPlace)
                                        }
                                }
                            }
                        }
                    }
                    .onDelete(perform: removeRows)
                }
                Spacer()
                Button {
                    
                    if (editing == .adding && text.count > 0) {
                        editing = .none
                        self.focusedCareer = nil
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
                        
                        Text("Manage Careers")
                            .font(.title2)
                    }
                }
            }
        }
    }

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let careers = [
            CareerType(name: "Front-end"),
            CareerType(name: "Back-end"),
            CareerType(name: "Fullstack"),
            CareerType(name: "DevOps"),
            CareerType(name: "UI"),
            CareerType(name: "Technical Writer")
        ]
        
        careers.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return CareerManageView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
