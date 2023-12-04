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
//  AppNavigationStacks.swift
//  asagiri
//
//  Created by irony on 26/11/2023.
//

import SwiftUI
import SwiftData

class PathManager: ObservableObject {
    var path = NavigationPath()
}

struct AppNavigationStack : View {
    
    
    // https://stackoverflow.com/questions/75251507/swiftui-error-update-navigationauthority-bound-path-tried-to-update-multiple-ti
    // As the path variable is passed via binding, the warning "Update NavigationAuthority bound path tried to update multiple times per frame." will occur
    @State var pathManager = PathManager()
    
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
            ApplicationListView(pathManager: $pathManager)
                .navigationDestination(for: PageType.self) { dest in
                    switch dest {
                    case .home:
                        ApplicationListView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    case .jd_list:
                        JDListView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    case .settings:
                        SettingsView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    case .create_new_jd:
                        CreateNewJDView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    case .career_manage:
                        CareerManageView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    case .tag_manage:
                        TagManageView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    case .analytics:
                        AnalyticsView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .navigationDestination(for: JobDescription.self) { jd in
                    CreateNewApplicationView(pathManager: $pathManager, jobDescription: jd)
                        .navigationBarBackButtonHidden(true)
                }
                .navigationDestination(for: Application.self) { app in
                    ApplicationPreviewView(pathManager: $pathManager, app: app)
                        .navigationBarBackButtonHidden(true)
                }
                .navigationDestination(for: NavigateToCompanyCreateArguments.self) { args in
                    CreateNewCompanyView(
                        pathManager: $pathManager,
                        onCompletion: args.onCompletion)
                    .navigationBarBackButtonHidden(true)
                }
        }
        
    }
}

enum PageType {
    case home, jd_list, settings, create_new_jd, career_manage, tag_manage, analytics
}


#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let careers = [
            CareerType(name: "Front-end"),
            CareerType(name: "Back-end")
        ]
        
        
        careers.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        let companies = [
            Company(name: "New Co", website: ""),
            Company(name: "Cat Inc", website: "")
        ]
        
        
        companies.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return AppNavigationStack()
            .modelContainer(previewContainer)
        
    }
}
