//
//  SettingsView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI

struct SettingsView: View {

    @Binding var pathManager:PathManager

    @State private var displayMenuBar: Bool = false    
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: CareerManageView(pathManager: $pathManager)
                        .navigationBarBackButtonHidden(), label: {
                        Text("Manage careers")
                    })
                    
                    Spacer()
                        .frame(height: 32)
                    
                    NavigationLink(destination: TagManageView(pathManager: $pathManager)
                        .navigationBarBackButtonHidden(), label: {
                        Text("Manage tags")
                    })
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
                        
                        NavigationLink(destination: ApplicationListView(pathManager: $pathManager), label: {
                            Label("Home", systemImage: "house.fill")
                        })
                        
                        Label("Menu", systemImage: "gear")
                            .foregroundColor(.black)
                    }
                } else {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = true
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                        
                        Text("Settings")
                            .font(.title2)
                    }
                }
            }
        }
    }

#Preview {
    SettingsView(pathManager: .constant(PathManager()))
}
