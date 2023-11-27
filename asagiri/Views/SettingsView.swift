//
//  SettingsView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var displayMenuBar: Bool = false
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: CareerManageView().navigationBarBackButtonHidden(), label: {
                        Text("Manage careers")
                    })
                    
                    Spacer()
                        .frame(height: 32)
                    
                    NavigationLink(destination: TagManageView().navigationBarBackButtonHidden(), label: {
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
                        
                        Button {
                            
                        } label: {
                            Label("Menu", systemImage: "house.fill")
                        }
                        
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
}

#Preview {
    SettingsView()
}
