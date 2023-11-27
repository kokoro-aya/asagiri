//
//  AppNavigationStacks.swift
//  asagiri
//
//  Created by irony on 26/11/2023.
//

import SwiftUI
import SwiftData

class PathManager: ObservableObject {
    @Published var path = NavigationPath()
}

struct AppNavigationStack : View {
    
    @StateObject var pathManager = PathManager()
    
//    let companies = [
//        Company(name: "Company 1", website: "com.1"),
//        Company(name: "Company 2", website: "com.2"),
//        Company(name: "Company 3", website: "com.3"),
//        Company(name: "Company 4", website: "com.4"),
//        Company(name: "Company 5", website: "com.5"),
//    ]
//
//    let allJobTypes = [
//        CareerType(name: "Front-end"),
//        CareerType(name: "Back-end"),
//        CareerType(name: "Fullstack"),
//    ]
    
    var body: some View {
        NavigationStack(path: $pathManager.path) {
            List {
                ApplicationListView()
                    .environmentObject(pathManager)
            }
            .navigationDestination(for: JobDescription.self) { jd in
                CreateNewApplicationView(jobDescription: jd)
                    .environmentObject(pathManager)
            }
            .navigationDestination(for: String.self) { label in
                switch label {
                case "applications": ApplicationListView()
                        .environmentObject(pathManager)
                case "settings": SettingsView()
                        .environmentObject(pathManager)
                default: ApplicationListView()
                        .environmentObject(pathManager)
                }
            }
            .environmentObject(pathManager)
        }
    }
}


#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        
        return AppNavigationStack()
            .modelContainer(previewContainer)
        
    }
}



//struct AppNavigationStack: View {
//    
//    @StateObject var pathManager = PathManager()
//    
//    var body: some View {
//        NavigationStack(path: $pathManager.path) {
//            List {
//                NavigationLink("SubView1", value: 1)
//                NavigationLink("SubView2", value: Target.subView2)
//                NavigationLink("SubView3", value: 3)
//                NavigationLink("SubView4", value: 4)
//            }
//            .navigationDestination(for: Target.self) { target in
//                switch target {
//                case .subView1:
//                    SubView1()
//                case .subView2:
//                    SubView2()
//                }
//            }
//            .navigationDestination(for: Int.self) { target in
//                switch target {
//                case 1:
//                    SubView1()
//                case 3:
//                    SubViewNum(index: 3)
//                default:
//                    SubViewNum(index: target)
//                }
//            }
//        }
//        .environmentObject(pathManager)
//        .task {
//            pathManager.path.append(3)
//            pathManager.path.append(1)
//            pathManager.path.append(Target.subView2)
//        }
//    }
//}
//
//enum Target {
//    case subView1, subView2
//}
//
//struct SubView1: View {
//    @EnvironmentObject var pathManager:PathManager
//    var body: some View {
//        Text("SubView 1")
//        List{
//            NavigationLink("SubView2", value: Target.subView2)
//            NavigationLink("subView3",value: 3)
//            Button("go to SubView3"){
//                pathManager.path.append(3)
//            }
//            Button("返回根视图"){
//                pathManager.path.removeLast(pathManager.path.count)
//            }
//            Button("返回上层视图"){
//                pathManager.path.removeLast()
//            }
//        }
//    }
//}
//
//struct SubView2: View {
//    @EnvironmentObject var pathManager:PathManager
//    var body: some View {
//        Text("SubView 2")
//        List{
//            NavigationLink("SubView1", value: Target.subView1)
//            NavigationLink("subView3",value: 3)
//            Button("go to SubView4"){
//                pathManager.path.append(4)
//            }
//            Button("返回根视图"){
//                pathManager.path.removeLast(pathManager.path.count)
//            }
//            Button("返回上层视图"){
//                pathManager.path.removeLast()
//            }
//        }
//    }
//}
//
//struct SubViewNum: View {
//    @EnvironmentObject var pathManager:PathManager
//    
//    var index: Int
//    
//    init(index: Int) {
//        self.index = index
//    }
//    
//    var body: some View {
//        Text("SubView \(index)")
//        List{
//            NavigationLink("SubView1", destination: SubView1())
//            NavigationLink("SubView2", destination: SubView2())
//            Button("go to SubView1"){
//                pathManager.path.append(1)
//            }
//            Button("返回根视图"){
//                pathManager.path.removeLast(pathManager.path.count)
//            }
//            Button("返回上层视图"){
//                pathManager.path.removeLast()
//            }
//        }
//    }
//}

