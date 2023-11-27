//
//  ContentView.swift
//  asagiri
//
//  Created by irony on 16/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
       AppNavigationStack()
    }
}

