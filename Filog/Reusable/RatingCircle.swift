//
//  RatingCircle.swift
//  Filog
//
//  Created by Jiyoung Park on 4/19/25.
//

import SwiftUI

struct RatingCircle: View {
    let value: Double
    var size: CGFloat = 46
    var font: Font = .semibold18
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.white)
                .frame(width: size, height: size)
            
            Circle()
                .stroke(lineWidth: 3)
                .foregroundStyle(.primaryBlue)
                .opacity(0.3)
                .frame(width: size - 5, height: size - 5)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(value * 0.01))
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.primaryBlue)
                .frame(width: size - 5, height: size - 5)
                .rotationEffect(.degrees(-90))
            
            Text(String(format: "%.1f", value / 10))
                .font(font)
                .kerning(1.0)
                .foregroundStyle(.primaryBlue)
        }
    }
}
