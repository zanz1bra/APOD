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
    
    //MARK: - Saving to Core Data
    func saveToCoreData(apod: APOD) {
        let context = persistentContainer.viewContext
        let favoriteAPOD = FavoriteAPOD(context: context)
        
        favoriteAPOD.imageUrl = apod.url
        favoriteAPOD.date = apod.date
        favoriteAPOD.copyright = apod.copyright
        favoriteAPOD.explanation = apod.explanation
        favoriteAPOD.title = apod.title
        
        do {
            try context.save()
            print("Saved to Core Data")
        } catch {
            print("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Fetching from Core Data
    func fetchFavorites() -> [FavoriteAPOD] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - Deleting from Core Data
    func deleteFavorite(apod: FavoriteAPOD) {
        let context = persistentContainer.viewContext
        context.delete(apod)
        
        do {
            try context.save()
            print("Deleted from Core Data")
        } catch {
            print("Error deleting from Core Data: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Check if favorite is already added
    
    func checkIfFavorite(date: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorites: \(error.localizedDescription)")
            return false
        }
    }
}
