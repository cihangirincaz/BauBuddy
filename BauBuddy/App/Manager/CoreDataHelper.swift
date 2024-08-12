//
//  CoreDataHelper.swift
//  BauBuddy
//
//  Created by cihangirincaz on 11.08.2024.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTask(task: String, title: String, descriptionTask: String, colorCode: String) {
        
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context) as! Tasks
        
        newTask.task = task
        newTask.title = title
        newTask.descriptionTask = descriptionTask
        newTask.colorCode = colorCode
        newTask.uuid = UUID()
        
        do {
            try context.save()
            print("Task saved successfully.")
        } catch {
            print("Task could not be saved: \(error.localizedDescription)")
        }
    }
    
    func fetchTasks() -> [Tasks] {
        let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Data retrieval error: \(error.localizedDescription)")
            return []
        }
    }
}
