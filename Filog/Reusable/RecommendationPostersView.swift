//
//  RecommendationPostersView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/30.
//

import SwiftUI
import CachedAsyncImage

struct RecommendationPostersView: View {
    @State var films: [FilmData]
    
    var body: some View {
        VStack {
            Spacer()
            
            NavigationLink(destination: FilmDetailView(filmId: films.first!.id)) {
                RecommendationPosterView(film: films.first!, width: UIScreen.main.bounds.size.width / 2, rank: 1, color: Color("Red"), fontSize: 20)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(1..<films.count) { idx in
                        NavigationLink(destination: FilmDetailView(filmId: films[idx].id)) {
                            RecommendationPosterView(film: films[idx], width: (UIScreen.main.bounds.size.width - 32) / 2.5, rank: idx + 1, color: Color("Blue"), fontSize: 18)
                        }
                    }
                }
                .padding(.horizontal, 36)
            }
        }
    }
}

struct RecommendationPosterView: View {
    let film: FilmData
    let width: CGFloat
    let rank: Int?
    let color: Color
    let fontSize: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                CachedAsyncImage(url: film.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Utils.placeholderColor
                    }
                }
                .aspectRatio(168/248, contentMode: .fit)
                .cornerRadius(4)
                .shadow(radius: 4)
                .frame(width: width)
                
                if rank != nil {
                    ZStack {
                        Text(String(rank!))
                            .offset(x: 2)

                        Text(String(rank!))
                            .offset(y: -2)

                        Text(String(rank!))
                            .offset(y: 2)

                        Text(String(rank!))
                            .offset(x: -2)
                        
                        Text(String(rank!))
                            .foregroundColor(color)
                    }
                    .foregroundColor(.white)
                    .font(.system(size: rank == 1 ? 128 : 96, weight: .semibold))
                    .padding(.bottom, -20)
                    .offset(x: -30)
                }
            }
            Text(film.title)
                .lineLimit(1)
                .frame(width: width)
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
        }
    }
}
