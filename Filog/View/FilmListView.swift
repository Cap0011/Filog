//
//  FilmListView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

@MainActor
struct FilmListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ])
    
    private var films: FetchedResults<Film>
    
    @ObservedObject private var nowPlayingState = FilmListState()
    @ObservedObject private var upcomingState = FilmListState()
    @ObservedObject private var topRatedState = FilmListState()
    @ObservedObject private var popularState = FilmListState()
    
    @State var isShowingSearchView = false
    @State private var isLoaded = false
    @ObservedObject var filmSearchState = FilmSearchState()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 32)
                        HStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .padding(.leading, 8)
                            Text("Look up films")
                                .font(.custom(FontManager.rubikGlitch, size: 16))
                            Spacer()
                        }
                        .foregroundColor(Color("Blue"))
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        isShowingSearchView.toggle()
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            if nowPlayingState.films != nil {
                                FilmPosterCarouselView(title: "Now Playing", films: nowPlayingState.films!)
                                    .padding(.top, 16)
                            } else {
                                LoadingView(isLoading: nowPlayingState.isLoading, error: nowPlayingState.error) {
                                    Task {
                                        await self.nowPlayingState.loadFilms(with: .nowPlaying)
                                    }
                                }
                            }
                            
                            if upcomingState.films != nil {
                                FilmBackdropCarouselView(title: "Upcoming", films: upcomingState.films!)
                            } else {
                                LoadingView(isLoading: upcomingState.isLoading, error: upcomingState.error) {
                                    Task {
                                        await self.upcomingState.loadFilms(with: .upcoming)
                                    }
                                }
                            }
                            
                            if topRatedState.films != nil {
                                FilmBackdropCarouselView(title: "Top rated", films: topRatedState.films!)
                            } else {
                                LoadingView(isLoading: topRatedState.isLoading, error: topRatedState.error) {
                                    Task {
                                        await self.topRatedState.loadFilms(with: .topRated)
                                    }
                                }
                            }
                            
                            if popularState.films != nil {
                                FilmBackdropCarouselView(title: "Popular", films: popularState.films!)
                            } else {
                                LoadingView(isLoading: popularState.isLoading, error: popularState.error) {
                                    Task {
                                        await self.popularState.loadFilms(with: .popular)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingSearchView) {
                FilmSearchView(filmSearchState: filmSearchState, isShowingSheet: self.$isShowingSearchView)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Filog")
                        .font(.custom(FontManager.rubikGlitch, size: 20))
                        .foregroundColor(.white)
                        .accessibilityAddTraits(.isHeader)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Constants.shared.films = films.filter{ $0.genre >= 0 }
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
}

struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
