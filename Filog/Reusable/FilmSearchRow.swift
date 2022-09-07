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
        VStack {
            HStack(spacing: 24) {
                CachedAsyncImage(url: film.posterURL)  { image in
                    image
                        .resizable()
                } placeholder: {
                    Utils.placeholderColor
                }
                .aspectRatio(168/248 ,contentMode: .fit)
                .frame(width: 80)
                .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(film.title)
                        .font(.system(size: 20, weight: .black))
                    Text(film.yearText)
                        .font(.system(size: 16, weight: .regular))
                }
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Rectangle()
                .frame(height: 0.3)
                .foregroundColor(Color("LightGrey"))
                .padding(.horizontal, 16)
        }
    }
}

