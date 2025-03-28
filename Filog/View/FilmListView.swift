//
//  FilmListView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

@MainActor
struct FilmListView: View {
    @ObservedObject private var nowPlayingState = FilmListState()
    @ObservedObject private var upcomingState = FilmListState()
    @ObservedObject private var topRatedState = FilmListState()
    @ObservedObject private var popularState = FilmListState()
    
    @State private var isLoaded = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                searchButton
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        if let films = nowPlayingState.films {
                            FilmCarouselView(title: "Now Playing", films: films, imageType: .largePoster)
                        } else {
                            LoadingView(isLoading: nowPlayingState.isLoading, error: nowPlayingState.error) {
                                Task {
                                    await self.nowPlayingState.loadFilms(with: .nowPlaying)
                                }
                            }
                        }
                        
                        if let films = upcomingState.films {
                            FilmCarouselView(title: "Upcoming", films: films, imageType: .smallPoster)
                        } else {
                            LoadingView(isLoading: upcomingState.isLoading, error: upcomingState.error) {
                                Task {
                                    await self.upcomingState.loadFilms(with: .upcoming)
                                }
                            }
                        }
                        
                        if let films = popularState.films {
                            FilmCarouselView(title: "Popular", films: films, imageType: .backdrop)
                        } else {
                            LoadingView(isLoading: topRatedState.isLoading, error: topRatedState.error) {
                                Task {
                                    await self.topRatedState.loadFilms(with: .topRated)
                                }
                            }
                        }
                        
                        if let films = topRatedState.films {
                            FilmCarouselView(title: "Top rated", films: films, imageType: .backdrop)
                        } else {
                            LoadingView(isLoading: popularState.isLoading, error: popularState.error) {
                                Task {
                                    await self.popularState.loadFilms(with: .popular)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 44)
                }
                .scrollIndicators(.hidden)
            }
            .background(.white)
            .navigationBarTitleDisplayMode(.inline)
        }
        .readSize { size in
            Utils.screenWidth = size.width
        }
        .onAppear {
            if !isLoaded {
                Task {
                    await self.nowPlayingState.loadFilms(with: .nowPlaying)
                    await self.upcomingState.loadFilms(with: .upcoming)
                    await self.topRatedState.loadFilms(with: .topRated)
                    await self.popularState.loadFilms(with: .popular)
                    
                    isLoaded = true
                }
            }
        }
    }
    
    var searchButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 38)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 2, y: 2)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray7A)
                
                Text("Look up films and people")
                    .font(.regular16)
                    .foregroundStyle(.graya7)
                    
                Spacer()
            }
            .padding(.horizontal, 12)
        }
    }
}

struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
