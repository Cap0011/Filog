//
//  SearchHistoryManager.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import Foundation

class SearchHistoryManager: ObservableObject {
    static let shared = SearchHistoryManager()
    
    private let key = "historyArray"
    private let maxNumber = 10
    
    @Published var history: [String] {
        didSet {
            UserDefaults.standard.set(history, forKey: key)
        }
    }
    
    private init() {
        self.history = UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }
    
    func addHistory(_ element: String) {
        var updatedHistory = history
        updatedHistory.insert(element, at: 0)
        
        if updatedHistory.count > maxNumber {
            updatedHistory.removeLast()
        }
        
        history = updatedHistory
    }
    
    func deleteHistory(at index: Int) {
        history.remove(at: index)
    }
    
    func clearHistory() {
        history = []
    }
}
