//
//  Binding.swift
//  Filog
//
//  Created by Jiyoung Park on 5/7/25.
//

import SwiftUI

extension Binding {
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
