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
//  Export+ImportView.swift
//  asagiri
//
//  Created by irony on 03/12/2023.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers


/*
  The implementation of export/import features have been inspired by following posts:
 - https://stackoverflow.com/questions/67336152/swiftui-fileexporter-exporting-only-1-document
 - https://stackoverflow.com/questions/73013526/how-to-save-a-json-file-in-documents-directory
 - https://swiftwithmajid.com/2023/05/10/file-importing-and-exporting-in-swiftui/
 */

enum AfterDialog {
    case import_success, import_failure
    case export_success, export_failure
    case none
}

struct ProfileDocument : FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    var companies: [Company]
    var name: String
    
    init (companies: [Company], name: String) {
        self.companies = companies
        self.name = name
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        let companies = try JSONDecoder().decode([Company].self, from: data)
        
        self.companies = companies
        self.name = configuration.file.filename ?? "profile"
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let encoded: Data = try! jsonEncoder.encode(companies)
        
        let fileWrapper = FileWrapper(regularFileWithContents: encoded)
        fileWrapper.filename = self.name
        return fileWrapper
    }
    
    
}

struct Export_ImportView: View {
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var displayMenuBar: Bool = false
    
    @State private var importing = false
    
    @State private var importAlert = false
    
    @State private var importLoading = false
    
    @State private var exporting = false
    
    @State private var afterDialog = false
    
    @State private var afterDialogReason: AfterDialog = .none
    
    @Query var companies: [Company]
    
    @State var _exportText: ProfileDocument? = nil
    
    var exportText: ProfileDocument? {
        return _exportText
    }
    
    
    func exportToFile() {
        
        _exportText = ProfileDocument(companies: companies, name: "asagiri-profile")
        exporting = true
    }
    
    func importFromFile(url: URL) {
        Task {
            if url.startAccessingSecurityScopedResource() {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    print(data)
                    
                    let modelContextKey = CodingUserInfoKey(rawValue: "modelcontext")!
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.userInfo[modelContextKey] = modelContext
                    
                    
                    try modelContext.delete(model: Application.self)
                    try modelContext.delete(model: JobDescription.self)
                    try modelContext.delete(model: Company.self)
                    try modelContext.delete(model: Resume.self)
                    try modelContext.delete(model: CoverLetter.self)
                    
                    let decoded = try decoder.decode([Company].self, from: data)
                    
                    let results = decoded
                    
                    // Processing de-duplication of careers
                    
                    
                    // Fetch descriptors for retrieving SwiftData data
                    let careerDescriptor = FetchDescriptor<CareerType>(sortBy: [SortDescriptor(\.name)])
                    let jobDescriptionDescriptor = FetchDescriptor<JobDescription>()
                    
                    // find out all inserted types and get un-duplicate names
                    let insertedTypes = try modelContext.fetch(careerDescriptor)
                    let careerNames = Set(insertedTypes.map { $0.name })
                    
                    // Build two groups of these career types: first occurences of each one; and their duplicata
                    let firstCareers = careerNames.map { name in insertedTypes.first(where: { $0.name == name }) }
                    let duplicatedCareers = insertedTypes.filter { !firstCareers.contains($0) }
                    
                    // Retrieve all job descriptions
                    let existingJDs = try modelContext.fetch(jobDescriptionDescriptor)
                    
                    // Rearrange job career type in case of duplicata
                    existingJDs.forEach { job in
                        if let match = duplicatedCareers.first(where: { $0 == job.type }) {
                            job.type = firstCareers.first(where: { $0!.name == match.name })!
                        }
                    }
                    
                    // Remove all duplicated job types
                    duplicatedCareers.forEach {
                        modelContext.delete($0)
                    }
                    
                    // TODO: Same process for tags
                    
                    importLoading = false
                    url.stopAccessingSecurityScopedResource()
                    
                    afterDialog = true
                    afterDialogReason = .import_success
                } catch {
                    print("Invalid data")
                    print(error)
                    importLoading = false
                    url.stopAccessingSecurityScopedResource()
                    
                    afterDialog = true
                    afterDialogReason = .import_failure
                }
            } else {
                print("Access denied")
                importLoading = false
                
                afterDialog = true
                afterDialogReason = .import_failure
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Button("Import") {
                importAlert = true
            }
            .alert("This operation will erase your data", isPresented: $importAlert) {
                Button("OK", role: .destructive) {
                    importing = true
                }
                Button("Cancel", role: .cancel) {}
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.json]
            ) { result in
                switch result {
                case .success(let url):
                    do {
                        importLoading = true
                        
                        importFromFile(url: url)
                        
                        // The following snippet may solve an issue of not able to load file from picker
                        // https://www.hackingwithswift.com/forums/swiftui/error-using-fileimporter-and-fileexporter/17548
                        // This issue seems to be solved
                        
//                        guard url.startAccessingSecurityScopedResource() else {
//                            print("Failed to start access")
//                            importLoading = false
//                            return
//                        }
//                        
//                        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
//                        let tmpDestUrl = cacheDir.appendingPathComponent(url.lastPathComponent)
//                        
//                        if let dataFromUrl = NSData(contentsOf: url) {
//                            if dataFromUrl.write(to: tmpDestUrl, atomically: true) {
//                                print("File copied to temp directory [\(tmpDestUrl.path)]")
//                                importFromFile(url: tmpDestUrl)
//                            } else {
//                                print("Error copying file")
//                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
//                            }
//                        }
//                        url.stopAccessingSecurityScopedResource()
                        
                    } catch {
                        print(error)
                        afterDialog = true
                        afterDialogReason = .import_failure
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    afterDialog = true
                    afterDialogReason = .import_failure
                }
            }
            .padding(8)
            Button("Export") {
                exportToFile()
            }
            .fileExporter(isPresented: $exporting,
                          document: exportText,
                          contentType: .json,
                          onCompletion: { _ in
                _exportText = nil
                exporting = false
                afterDialog = true
                afterDialogReason = .export_success
            })
            Spacer()
        }
        .alert(isPresented: $afterDialog) {
            switch afterDialogReason {
            case .import_success:
                return Alert(title: Text("Success"), message: Text("Successfully imported your data"), dismissButton: .default(Text("OK")) {
                    afterDialog = false
                    afterDialogReason = .none
                })
            case .import_failure:
                return Alert(title: Text("Failed"), message: Text("Failed to import your data"), dismissButton: .default(Text("OK")) {
                    afterDialog = false
                    afterDialogReason = .none
                })
            case .export_success:
                return Alert(title: Text("Success"), message: Text("Successfully exported your data"), dismissButton: .default(Text("OK")) {
                    afterDialog = false
                    afterDialogReason = .none
                })
            case .export_failure:
                return Alert(title: Text("Failed"), message: Text("Failed to export your data"), dismissButton: .default(Text("OK")) {
                    afterDialog = false
                    afterDialogReason = .none
                })
            case .none:
                return Alert(title: Text("Nothing"), message: Text("This alert should not display"), dismissButton: .default(Text("OK")) {
                    afterDialog = false
                    afterDialogReason = .none
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
                    
                    NavigationLink(value: PageType.home, label: {
                        Label("Home", systemImage: "house.fill")
                    })
                    
                    NavigationLink(value: PageType.jd_list, label: {
                        Label("JD List", systemImage: "bag.fill")
                    })
                    
                    Label("Settings", systemImage: "gear")
                        .foregroundColor(.black)
                        .padding([.leading, .trailing], 10)
                    
                    NavigationLink(value: PageType.analytics, label: {
                        Label("Analytics", systemImage: "chart.pie")
                    })

                }
            } else {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = true
                    } label: {
                        Label("Menu", systemImage: "line.3.horizontal")
                    }
                    
                    Text("Export/Import")
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let applications = [
            Application(jobDescription: JobDescription(title: "A", company: Company(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-12T12:00:00-08:00")),
                Event(type: .rejected, updateTime: createDateFromString("2023-10-13T14:50:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", company: Company(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-11T12:00:00-08:00")),
                Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-12T21:00:00-08:00")),
                Event(type: .interview(round: 2), updateTime: createDateFromString("2023-10-16T15:20:00-08:00")),
                Event(type: .interview(round: 3), updateTime: createDateFromString("2023-10-19T14:00:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", company: Company(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-17T12:00:00-08:00")),
                Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-18T14:30:00-08:00")),
                Event(type: .ghost, updateTime: createDateFromString("2023-10-22T14:20:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", company: Company(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", company: Company(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00")),
                Event(type: .oa, updateTime: createDateFromString("2023-11-15T13:00:00-08:00"))
            ])
        ]
        
        applications.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return Export_ImportView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
