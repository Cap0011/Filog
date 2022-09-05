//
//  FilmPosterCard.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI
import CachedAsyncImage

struct FilmPosterCard: View {
    let film: FilmData
    
    var body: some View {
        CachedAsyncImage(url: film.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default: Color.gray
            }
        }
        .aspectRatio(168/248, contentMode: .fit)
        .frame(width: 200)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
