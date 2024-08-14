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
    //MARK: For Saved Tasks
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
    //MARK: For "AllData" Model
    func fetchTasks() -> [Task] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllData")

        do {
            let results = try context.fetch(fetchRequest) as? [AllData]
            let tasks = results?.map { Task(coreDataTask: $0) } ?? []
            return tasks
        } catch let error {
            print("An error occurred while retrieving data: \(error.localizedDescription)")
            return []
        }
    }

    func saveTasksToCoreData(tasks: [Task]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        for task in tasks {
            let coreDataTask = NSEntityDescription.insertNewObject(forEntityName: "AllData", into: context) as! AllData
            coreDataTask.task = task.task
            coreDataTask.title = task.title
            coreDataTask.descriptionTask = task.description
            coreDataTask.colorCode = task.colorCode
            coreDataTask.uuid = UUID()
        }
        do {
            try context.save()
            print("All data was saved successfully.")
        } catch let error {
            print("An error occurred while saving data: \(error.localizedDescription)")
        }
    }

    //MARK: General
    func deleteAllData(entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                if let objectData = object as? NSManagedObject {
                    context.delete(objectData)
                }
            }
            try context.save()
            print("\(entity) All data in the entity has been deleted.")
        } catch let error {
            print("An error occurred while deleting data: \(error.localizedDescription)")
        }
    }
}
