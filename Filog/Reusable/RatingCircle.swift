//
//  RatingCircle.swift
//  Filog
//
//  Created by Jiyoung Park on 4/19/25.
//

import SwiftUI

struct RatingCircle: View {
    let value: Double
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
            
            Circle()
                .stroke(lineWidth: 3)
                .foregroundStyle(.primaryBlue)
                .opacity(0.3)
                .frame(width: 41, height: 41)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(value * 0.01))
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.primaryBlue)
                .frame(width: 41, height: 41)
                .rotationEffect(.degrees(-90))
            
            Text(String(format: "%.1f", value / 10))
                .font(.semibold18)
                .kerning(1.5)
                .foregroundStyle(.primaryBlue)
        }
    }
}
