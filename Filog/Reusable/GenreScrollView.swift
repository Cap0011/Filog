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
                        GenreView(idx: idx)
                        .onTapGesture {
                            selected = idx
                        }
                    } else {
                        // Selected
                        SelectedGenreView(idx: idx)
                        .onTapGesture {
                            selected = 0
                        }
                    }
                }
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
        }
    }
}
