//
//  CreateNewCompanyView.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewCompanyView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @EnvironmentObject var pathManager:PathManager
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    
    @State var website: String = ""
    
    var onCompletion: (_ company: Company) -> ()
    
    init (onCompletion: @escaping (_ company: Company) -> ()) {
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .font(.title3)
                        Spacer()
                    }
                    TextField("Company name", text: $name)
                        .padding([.leading], 6)
                    HStack {
                        Text("Website")
                            .font(.title3)
                        Spacer()
                    }
                    TextField("Website", text: $website)
                        .padding([.leading], 6)
                }
                Spacer()
                Divider()
                Button {
                    onCompletion(Company(name: name, website: website))
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Label("Save", systemImage: "paperplane.fill")
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
                        
                        //
                        
                        Label("Menu", systemImage: "house.fill")
                            .foregroundColor(.black)
                        
                        Button {
                            
                        } label: {
                            Label("Menu", systemImage: "gear")
                        }
                    }
                } else {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = true
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                        
                        Text("Create an application")
                            .font(.title2)
                    }
                }
                ToolbarItem {
                    Button {
                        pathManager.path.removeLast()
                    } label: {
                        Label("Go back", systemImage: "arrowshape.turn.up.backward")
                    }
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        
        return CreateNewCompanyView(onCompletion: { _ in })
            .modelContainer(previewContainer)
    }
}
