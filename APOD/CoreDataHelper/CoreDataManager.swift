//
//  CoreDataManager.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init () {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "APOD")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    } ()
    
    func saveToCoreData(apod: APOD) {
        let context = persistentContainer.viewContext
        let favoriteAPOD = FavoriteAPOD(context: context)
        
        favoriteAPOD.imageUrl = apod.url
        favoriteAPOD.date = apod.date
        favoriteAPOD.copyright = apod.copyright
        favoriteAPOD.explanation = apod.explanation
        
        do {
            try context.save()
            print("Saved to Core Data")
        } catch {
            print("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
}
