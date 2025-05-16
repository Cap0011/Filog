//
//  UIApplication.swift
//  Filog
//
//  Created by Jiyoung Park on 5/16/25.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
