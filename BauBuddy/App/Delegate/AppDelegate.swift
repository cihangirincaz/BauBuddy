//
//  AppDelegate.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        APIManager.shared.initializeAppData { success in
            if success {
                CoreDataHelper.shared.deleteAllData(entity: "AllData")
                CoreDataHelper.shared.saveTasksToCoreData(tasks: Globals.shared.tasks)
                let window = UIWindow(frame: UIScreen.main.bounds)
                let rootViewController = SplashVC()
                let navigationController = UINavigationController(rootViewController: rootViewController)
                navigationController.setNavigationBarHidden(true, animated: false)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                self.window = window
                print("Data was successfully extracted.")
            } else {
                print("Data retrieval failed.")
                Globals.shared.tasks = CoreDataHelper.shared.fetchTasks()
                let window = UIWindow(frame: UIScreen.main.bounds)
                let rootViewController = SplashVC()
                let navigationController = UINavigationController(rootViewController: rootViewController)
                navigationController.setNavigationBarHidden(true, animated: false)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                self.window = window
            }
        }
        return true
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BauBuddy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

