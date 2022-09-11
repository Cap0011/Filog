//
//  FilmDetailView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI
import CachedAsyncImage

struct FilmDetailView: View {
    let filmId: Int
    
    @ObservedObject private var filmDetailState = FilmDetailState()
    @ObservedObject private var filmSmiliarState = FilmListState()
    @ObservedObject private var filmRecommendationState = FilmListState()
    
    @State var isLoaded = false
    @State var isShowingAddToast = false
    @State var isShowingRemoveToast = false
    @State var isShowingSuccessToast = false
    
    var body: some View {
        ZStack {
            Color("Blue").ignoresSafeArea()
            ScrollView {
                LoadingView(isLoading: self.filmDetailState.isLoading, error: self.filmDetailState.error) {
                    Task {
                        await self.filmDetailState.loadFilm(id: self.filmId)
                    }
                }
                .padding(.top, 100)
                
                if filmDetailState.film != nil {
                    FilmDetailListView(film: filmDetailState.film!, similarFilms: filmSmiliarState.films, recommendationFilms: filmRecommendationState.films, isShowingAddToast: $isShowingAddToast, isShowingRemoveToast: $isShowingRemoveToast, isShowingSuccessToast: $isShowingSuccessToast)
                }
            }
            .ignoresSafeArea()
        }
        .toast(message: "Added to your watch list", isShowing: $isShowingAddToast, duration: Toast.short)
        .toast(message: "Removed from your watch list", isShowing: $isShowingRemoveToast, duration: Toast.short)
        .toast(message: "Your review was successfully added!", isShowing: $isShowingSuccessToast, duration: Toast.short)
        .onAppear {
            if !isLoaded {
                Task {
                    await self.filmDetailState.loadFilm(id: self.filmId)
                    await self.filmSmiliarState.loadSimilarFilms(id: self.filmId)
                    await self.filmRecommendationState.loadRecommendationFilms(id: self.filmId)
                    
                    isLoaded = true
                }
            }
        }
    }
}

struct FilmDetailListView: View {
    let film: FilmData
    let similarFilms: [FilmData]?
    let recommendationFilms: [FilmData]?
    
    @State private var selectedTrailer: FilmVideo?
    
    @State var isShowingSheet = false
    
    @Binding var isShowingAddToast: Bool
    @Binding var isShowingRemoveToast: Bool
    @Binding var isShowingSuccessToast: Bool
    
    @State var isAlreadyOnList = false
        
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("Blue").ignoresSafeArea()
            LazyVStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    FilmDetailImage(imageURL: self.film.backdropURL)
                    FilmRatingCircle(value: film.voteAverage * 10)
                        .offset(x: -16, y: -16)
                }
                HStack {
                    FilmPosterImage(imageURL: self.film.posterURL)
                        .shadow(radius: 4)
                        .offset(y: -50)
                        .padding(.bottom, -50)
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(film.title)
                                .font(.system(size: 22, weight: .black))
                            Text("\(film.yearText) · \(film.durationText)\(film.adultText)")
                                .font(.system(size: 16, weight: .semibold))
                            Text(film.genreText)
                                .lineLimit(1)
                                .font(.system(size: 16, weight: .light))
                                .padding(.top, -6)
                        }
                        
                        HStack(spacing: 12) {
                            if film.netflixSearchURL != nil {
                                Link(destination: film.netflixSearchURL!) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .foregroundColor(.black)
                                            .frame(width: 30, height: 30)
                                        Image("netflix")
                                            .resizable()
                                            .frame(width: 22, height: 40)
                                            .scaledToFit()
                                    }
                                }
                            }
                            Spacer()
                            if !isAlreadyOnList {
                                Image(systemName: "text.badge.plus")
                                    .onTapGesture {
                                        self.saveData(filmID: film.id, posterURL: film.posterURL)
                                        isAlreadyOnList.toggle()
                                        isShowingAddToast = true
                                    }
                            } else {
                                Image(systemName: "text.badge.checkmark")
                                    .onTapGesture {
                                        self.removeData(filmID: film.id)
                                        isAlreadyOnList.toggle()
                                        isShowingRemoveToast = true
                                    }
                            }
                            Image(systemName: "plus.bubble.fill")
                                .offset(y: 2)
                                .onTapGesture {
                                    isShowingSheet.toggle()
                                }
                        }
                        .padding(.top, 8)
                        .font(.system(size: 22))
                        .foregroundColor(Color("Red"))
                    }
                    .padding(.trailing, 8)
                    .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    if !film.overview.isEmpty {
                        Text("Overview")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color("Red"))
                            .padding(.bottom, 8)
                            .padding(.horizontal, 16)
                        Text(film.overview)
                            .padding(.bottom, 16)
                            .padding(.horizontal, 16)
                    }

                    if film.directors != nil && film.directors!.count > 0 {
                        Text("Director")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color("Red"))
                            .padding(.bottom, 8)
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(film.directors!){ director in
                                    NavigationLink(destination: PersonDetailView(id: director.id)) {
                                        FilmCastCard(name: director.name, character: nil, profileURL: director.profileURL)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 225)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    if film.cast != nil && film.cast!.count > 0 {
                        Text("Cast")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color("Red"))
                            .padding(.bottom, 8)
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(film.cast!.prefix(10)){ cast in
                                    NavigationLink(destination: PersonDetailView(id: cast.id)) {
                                        FilmCastCard(name: cast.name, character: cast.character, profileURL: cast.profileURL)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 245)
                        }
                        .padding(.bottom, 16)
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.top, 8)
                .minimumScaleFactor(1)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .regular))
                
                if film.videos != nil && film.videos!.results.count > 0 {
                    Text("Videos")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                        .padding(.horizontal, 16)
                    
                    YoutubeCarouselView(videos: film.videos!.results)
                        .padding(.bottom, 16)
                }
                
                if similarFilms != nil && similarFilms!.count > 0 {
                    Text("Similar films")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                        .padding(.leading, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(similarFilms!) { film in
                                NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                    RecommendationPosterView(film: film, width: (UIScreen.main.bounds.size.width - 32) / 2.5, rank: nil, color: Color("Blue"), fontSize: 20)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: (UIScreen.main.bounds.size.width - 32) / 2.5 / 2 * 3 + 20)
                    }
                    .padding(.bottom, 16)
                }
                
                if recommendationFilms != nil && recommendationFilms!.count > 0 {
                    Text("Also you might like...")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                        .padding(.leading, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(recommendationFilms!) { film in
                                NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                    RecommendationPosterView(film: film, width: (UIScreen.main.bounds.size.width - 32) / 2.5, rank: nil, color: Color("Blue"), fontSize: 20)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: (UIScreen.main.bounds.size.width - 32) / 2.5 / 2 * 3 + 20)
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet, content: {
                AddFilmView(isShowingSheet: $isShowingSheet, isShowingSuccessToast: $isShowingSuccessToast, selectedURL: film.posterURL, title: film.title, id: String(film.id), isSelected: true, genres: film.genres?.prefix(3).map { Constants.shared.genreDictionary[$0.id] ?? 0 } ?? [])
            })
            .lineSpacing(5)
            .ignoresSafeArea()
            .padding(.bottom, 100)
        }
        .onAppear {
            fetchListState(filmID: film.id)
        }
    }
    
    private func saveData(filmID: Int, posterURL: URL) {
        var savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        savedDictionary[String(filmID)] = posterURL.absoluteString
        UserDefaults.standard.set(savedDictionary, forKey: "ToWatchFilms")
    }
    
    private func removeData(filmID: Int) {
        var savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        savedDictionary[String(filmID)] = nil
        UserDefaults.standard.set(savedDictionary, forKey: "ToWatchFilms")
    }
    
    private func fetchListState(filmID: Int) {
        let savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        let result = savedDictionary[String(filmID)] != nil
        
        if result { isAlreadyOnList = true }
        else { isAlreadyOnList = false }
    }
}

struct FilmDetailImage: View {
    let imageURL: URL
    
    var body: some View {
        
        GeometryReader { geometry in
            CachedAsyncImage(url: imageURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default: Utils.placeholderColor
                }
            }
            .aspectRatio(9/5, contentMode: .fill)
            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
            .clipped()
            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
        }.frame(height: UIScreen.main.bounds.size.width * 5 / 9)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
}

struct FilmPosterImage: View {
    let imageURL: URL
    
    var body: some View {
        CachedAsyncImage(url: imageURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default: Utils.placeholderColor
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .frame(width: 120)
        .cornerRadius(4)
        .shadow(radius: 4)
    }
}

struct FilmRatingCircle: View {
    let value: Double
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("Blue"))
                .frame(width: 46, height: 46)
            
            Circle()
                .stroke(lineWidth: 3)
                .foregroundColor(Color("Red"))
                .opacity(0.3)
                .frame(width: 41, height: 41)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(value * 0.01))
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("Red"))
                .frame(width: 41, height: 41)
                .rotationEffect(.degrees(-90))
            
            Text(String(format: "%.1f", value / 10))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}
