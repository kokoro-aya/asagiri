//
//  CareerManageView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI
import SwiftData

struct CareerManageView: View {
    
    @State private var displayMenuBar = false
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var careerTypes: [CareerType]
    
    @State private var text = ""
    
    @FocusState private var focusedCareer: CareerType?
    
    @State private var adding = false
    
    var editingList: [CareerType] {
        if (adding) {
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
                            }
                        }
                    } else {
                        Text(item.name)
                    }
                }
                .onDelete(perform: removeRows)
            }
            Spacer()
            Button {
                
                if (adding == true && text.count > 0) {
                    adding = false
                    self.focusedCareer = nil
                }
                
                adding = true
            } label: {
                Label("Add", systemImage: "plus")
                    .padding(12)
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
        
        return CareerManageView()
            .modelContainer(previewContainer)
    }
}
