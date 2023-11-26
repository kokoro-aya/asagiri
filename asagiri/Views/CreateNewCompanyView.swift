//
//  CreateNewCompanyView.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewCompanyView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    
    @State var website: String = ""
    
    var onCompletion: (_ company: Company) -> ()
    
    init (onCompletion: @escaping (_ company: Company) -> ()) {
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Create a new company")
                    .font(.caption)
                Spacer()
            }
            Divider()
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
            
        }.padding(16)
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        
        return CreateNewCompanyView(onCompletion: { _ in })
            .modelContainer(previewContainer)
    }
}
