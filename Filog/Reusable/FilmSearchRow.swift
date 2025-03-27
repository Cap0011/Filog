//
//  FilmSearchRow.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI
import CachedAsyncImage

struct FilmSearchRow: View {
    var film: FilmData
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                CachedAsyncImage(url: film.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Color.grayf4
                    }
                }
                .aspectRatio(168/248 ,contentMode: .fill)
                .frame(width: 50)
                .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(film.title)
                        .lineLimit(1)
                        .font(.regular16)
                        .foregroundStyle(.primaryBlack)
                        .frame(height: 22)
                    
                    Text(film.yearText)
                        .font(.regular14)
                        .foregroundStyle(.gray7A)
                        .frame(height: 20)
                }
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.grayf4)
                .padding(.horizontal, -5)
        }
        .background(.white)
    }
}

