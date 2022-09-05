//
//  FilmBackdropCard.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI
import CachedAsyncImage

struct FilmBackdropCard: View {
    let film: FilmData
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: film.backdropURL)  { image in
                image
                    .resizable()
            } placeholder: {
                Color.gray
            }
            .aspectRatio(270/152, contentMode: .fit)
            .frame(width: 270)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            Text(film.title)
                .frame(width: 262, alignment: .leading)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 8)
                .truncationMode(.tail)
                .lineLimit(1)
        }
    }
}
