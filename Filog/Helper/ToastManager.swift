//
//  ToastManager.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import Foundation

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowingToast: Bool = false
}
