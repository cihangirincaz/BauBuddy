//
//  Task.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import Foundation

struct Task {
    let task: String
    let title: String
    let description: String
    let colorCode: String

    init?(json: [String: Any]) {
        guard let task = json["task"] as? String,
              let title = json["title"] as? String,
              let description = json["description"] as? String,
              let colorCode = json["colorCode"] as? String else { return nil }

        self.task = task
        self.title = title
        self.description = description
        self.colorCode = colorCode
    }
    
    //MARK: Alternative init function - for CoreData
    init(coreDataTask: Tasks) {
        self.task = coreDataTask.task ?? ""
        self.title = coreDataTask.title ?? ""
        self.description = coreDataTask.descriptionTask ?? ""
        self.colorCode = coreDataTask.colorCode ?? ""
    }
}
