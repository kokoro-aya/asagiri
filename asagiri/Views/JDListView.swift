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
//  JDListView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI
import SwiftData

struct JDListView: View {
    
    @Binding var pathManager:PathManager
    
    @Query private var jobDescriptions: [JobDescription]
    
    var body: some View {
        ScrollView {
            ForEach(jobDescriptions) { jd in
                JobDescriptionCard(jd: jd)
                    .padding([.leading, .trailing], 10)
            }
        }
    }
}


#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let jd0 = JobDescription(title: "technical writer", company: Company(name: "Company 0", website: "company0.com"), type: CareerType(name: "Writer"), intro: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", companyIntro: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.", responsibilities: "Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.", complementary: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.")
        
        let jd1 = JobDescription(title: "front-end developer", company: Company(name: "Company 1", website: "company1.com"), type: CareerType(name: "Front-end"))
        
        let jd2 = JobDescription(title: "backend developer", company: Company(name: "Company 2", website: "company2.com"), type: CareerType(name: "Back-end"))
        
        let jd3 = JobDescription(title: "devops", company: Company(name: "Company 3", website: "company3.com"), type: CareerType(name: "Devops"))
        
        let jd4 = JobDescription(title: "fullstack", company: Company(name: "Company 4", website: "company4.com"), type: CareerType(name: "Fullstack"))
        
        
        
        let apps = [jd0, jd1, jd2, jd3, jd4]
        
        apps.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        
        return JDListView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}


struct JobDescriptionCard: View {
    
    let jd: JobDescription
    
    @State var detailed: Bool = false
    
    init(jd: JobDescription) {
        self.jd = jd
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(jd.title)
                        .font(.headline)
                    Text(jd.company?.name ?? "")
                        .font(.subheadline)
                }
                Spacer()
                Text(jd.type?.name ?? "")
            }
            HStack(alignment: .bottom) {
                if (jd.intro.count > 0) {
                    Text("\(jd.intro.prefix(136).description) ...")
                }
                Spacer()
                Button {
                    
                } label: {
                    Text("Finish")
                }
            }
        }
        Divider()
            .padding([.bottom], 12)
    }
}
