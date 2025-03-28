//
//  Persistence.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/29.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FilmList")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
}

extension PersistenceController {
    func save() {
        guard container.viewContext.hasChanges else { return }
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func delete(item: Film) {
        container.viewContext.delete(item)
        save()
    }
}
