//
//  ToastManager.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import Foundation

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowingEmptyToast: Bool = false
    @Published var isShowingSaveToast: Bool = false
}
