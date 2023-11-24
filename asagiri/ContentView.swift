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
    @Query private var items: [Item]

    var body: some View {
        /*
         
         NavigationStack(path: $pathManager.path) {
            List {
                // All different views go here
            }
            .navigationDestination(for: Company.self) { target
                switch target {
                    case nil:
                        CreateNewJDView()
                    default:
                        CreateNewJDView(target)
                }
            }
            .navigationDestination(for: Application.self) { ... }
         }
         .environmentObject(pathManager)
         .task {
            ...
         }
         
         // source: https://fatbobman.com/posts/new_navigator_of_SwiftUI_4/
         
         */
        
        
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
