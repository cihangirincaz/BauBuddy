//
//  Task.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import Foundation

struct Task: Decodable {
    let task: String
    let title: String
    let description: String
    let colorCode: String
    
    //MARK: Alternative init function - for CoreData
    init(coreDataTask: Tasks) {
        self.task = coreDataTask.task ?? ""
        self.title = coreDataTask.title ?? ""
        self.description = coreDataTask.descriptionTask ?? ""
        self.colorCode = coreDataTask.colorCode ?? ""
    }
    init(coreDataTask: AllData) {
            self.task = coreDataTask.task ?? ""
            self.title = coreDataTask.title ?? ""
            self.description = coreDataTask.descriptionTask ?? ""
            self.colorCode = coreDataTask.colorCode ?? ""
        }
}
