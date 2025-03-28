//
//  ToastType.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

enum ToastType {
    case empty
    case save
    
    var message: String {
        switch self {
        case .empty:
            return "Write your thoughts before proceeding."
        case .save:
            return "Your review has been successfully saved!"
        }
    }
}
