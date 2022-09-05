//
//  FilmPosterCarouselView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

struct FilmPosterCarouselView: View {
    
    let title: String
    let films: [FilmData]
    
    var body: some View {
        ZStack {
            Color("Blue").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 20, weight: .black))
                    .padding(.leading, 24)
                    .foregroundColor(Color("Red"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(self.films) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                FilmPosterCard(film: film)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.bottom, 16)
        .onTapGesture {
            print(films)
        }
    }
}
