//
//  ResumeModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class Resume {
    var content: String
    
    var comments: String = ""
    
    var createTime: Date
    
    init(content: String) {
        self.content = content
        self.createTime = Date.now
    }
}
