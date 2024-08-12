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
    
    func fetchTasks(completion: @escaping ([Tasks]?, Error?) -> Void) {
          let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
          
          do {
              let tasks = try context.fetch(fetchRequest)
              completion(tasks, nil)
          } catch {
              completion(nil, error) 
          }
      }
    func deleteTask(task: Task, completion: @escaping (Error?) -> Void) {
           let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "task == %@ AND title == %@ AND descriptionTask == %@ AND colorCode == %@", task.task, task.title, task.description, task.colorCode)
           
           do {
               let tasksToDelete = try context.fetch(fetchRequest)
               for taskToDelete in tasksToDelete {
                   context.delete(taskToDelete)
               }
               try context.save()
               completion(nil)
           } catch {
               completion(error)
           }
       }
}
