//
//  GenreScrollView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct GenreScrollView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Genres.allCases.indices) { idx in
                    if idx != selected {
                        // Unselected
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("LightRed"), lineWidth: 1)
                                .frame(height: 30)
                            Text(Genres.allCases[idx].rawValue)
                                .padding(.horizontal, 8)
                                .foregroundColor(Color("LightRed"))
                        }
                        .onTapGesture {
                            selected = idx
                        }
                        .frame(minWidth: 76)
                    } else {
                        // Selected
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 32)
                                .foregroundColor(Color("Red"))
                            Text(Genres.allCases[idx].rawValue)
                                .padding(.horizontal, 8)
                                .foregroundColor(.white)
                        }
                        .frame(minWidth: 78)
                        .onTapGesture {
                            selected = 0
                        }
                    }
                }
                .font(.system(size: 14, weight: .black))
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
        }
    }
}
