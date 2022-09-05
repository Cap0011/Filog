//
//  FilogApp.swift
//  Filog
//
//  Created by Jiyoung Park on 2022/09/05.
//

import SwiftUI

@main
struct FilmLogApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TotalView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
