//
//  AppNavigationStacks.swift
//  asagiri
//
//  Created by irony on 26/11/2023.
//

import SwiftUI

class PathManager: ObservableObject {
    @Published var path = NavigationPath()
}

struct AppNavigationStack: View {
    
    @StateObject var pathManager = PathManager()
    
    var body: some View {
        NavigationStack(path: $pathManager.path) {
            List {
                NavigationLink("SubView1", value: 1)
                NavigationLink("SubView2", value: Target.subView2)
                NavigationLink("SubView3", value: 3)
                NavigationLink("SubView4", value: 4)
            }
            .navigationDestination(for: Target.self) { target in
                switch target {
                case .subView1:
                    SubView1()
                case .subView2:
                    SubView2()
                }
            }
            .navigationDestination(for: Int.self) { target in
                switch target {
                case 1:
                    SubView1()
                case 3:
                    SubViewNum(index: 3)
                default:
                    SubViewNum(index: target)
                }
            }
        }
        .environmentObject(pathManager)
        .task {
            pathManager.path.append(3)
            pathManager.path.append(1)
            pathManager.path.append(Target.subView2)
        }
    }
}

enum Target {
    case subView1, subView2
}

struct SubView1: View {
    @EnvironmentObject var pathManager:PathManager
    var body: some View {
        Text("SubView 1")
        List{
            NavigationLink("SubView2", value: Target.subView2)
            NavigationLink("subView3",value: 3)
            Button("go to SubView3"){
                pathManager.path.append(3)
            }
            Button("返回根视图"){
                pathManager.path.removeLast(pathManager.path.count)
            }
            Button("返回上层视图"){
                pathManager.path.removeLast()
            }
        }
    }
}

struct SubView2: View {
    @EnvironmentObject var pathManager:PathManager
    var body: some View {
        Text("SubView 2")
        List{
            NavigationLink("SubView1", value: Target.subView1)
            NavigationLink("subView3",value: 3)
            Button("go to SubView4"){
                pathManager.path.append(4)
            }
            Button("返回根视图"){
                pathManager.path.removeLast(pathManager.path.count)
            }
            Button("返回上层视图"){
                pathManager.path.removeLast()
            }
        }
    }
}

struct SubViewNum: View {
    @EnvironmentObject var pathManager:PathManager
    
    var index: Int
    
    init(index: Int) {
        self.index = index
    }
    
    var body: some View {
        Text("SubView \(index)")
        List{
            NavigationLink("SubView1", destination: SubView1())
            NavigationLink("SubView2", destination: SubView2())
            Button("go to SubView1"){
                pathManager.path.append(1)
            }
            Button("返回根视图"){
                pathManager.path.removeLast(pathManager.path.count)
            }
            Button("返回上层视图"){
                pathManager.path.removeLast()
            }
        }
    }
}

#Preview {
    AppNavigationStack()
}
