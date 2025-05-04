//
//  FilmDetailView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI
import CachedAsyncImage

struct FilmDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let filmId: Int
    
    @StateObject private var filmViewModel = DetailViewModel<FilmData>()
    
    //    @ObservedObject private var filmDetailState = FilmDetailState()
    //    @ObservedObject private var filmSmiliarState = FilmListState()
    //    @ObservedObject private var filmRecommendationState = FilmListState()
    //
    //    @State var isLoaded = false
    //    @State var isShowingAddToast = false
    //    @State var isShowingRemoveToast = false
    //    @State var isShowingSuccessToast = false
    //
    //    @State var filmTitle = ""
    
    var body: some View {
        //        ZStack {
        //            Color(.white).ignoresSafeArea()
        //            ScrollView {
        //                LoadingView(isLoading: self.filmDetailState.isLoading, error: self.filmDetailState.error) {
        //                    Task {
        //                        await self.filmDetailState.loadFilm(id: self.filmId)
        //                    }
        //                }
        //                .padding(.top, 100)
        //
        //                if filmDetailState.film != nil {
        //                    FilmDetailListView(film: filmDetailState.film!, similarFilms: filmSmiliarState.films, recommendationFilms: filmRecommendationState.films, isShowingAddToast: $isShowingAddToast, isShowingRemoveToast: $isShowingRemoveToast, isShowingSuccessToast: $isShowingSuccessToast)
        //                        .onAppear {
        //                            filmTitle = filmDetailState.film!.title
        //                        }
        //                }
        //            }
        //            .ignoresSafeArea()
        //        }
        //        .toast(message: "<\(filmTitle)> has added to your watch list", isShowing: $isShowingAddToast, duration: Toast.short)
        //        .toast(message: "<\(filmTitle)> has removed from your watch list", isShowing: $isShowingRemoveToast, duration: Toast.short)
        //        .toast(message: "Your review has successfully added!", isShowing: $isShowingSuccessToast, duration: Toast.short)
        //        .onAppear {
        //            if !isLoaded {
        //                Task {
        //                    await self.filmDetailState.loadFilm(id: self.filmId)
        //                    await self.filmSmiliarState.loadSimilarFilms(id: self.filmId)
        //                    await self.filmRecommendationState.loadRecommendationFilms(id: self.filmId)
        //
        //                    isLoaded = true
        //                }
        //            }
        //        }
        ScrollView(.vertical) {
            if let film = filmViewModel.detail {
                VStack(alignment: .leading, spacing: 0) {
                    header(film: film)
                    
                    body(film: film)
                }
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .background(.white)
        .task {
            filmViewModel.id = filmId
        }
    }
    
    private func header(film: FilmData) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                ParallaxHeaderImage(imageURL: film.backdropURL)
                
                Utils.backButton
                    .padding(.top, 56)
                    .padding(.leading, 20)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        RatingCircle(value: (film.voteAverage ?? 0) * 10)
                            .padding(.trailing, 16)
                            .padding(.bottom, 12)
                    }
                }
            }
            
            HStack(alignment: .bottom, spacing: 12) {
                PosterImage(imageURL: film.posterURL)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(film.displayTitle)
                        .font(.semibold18)
                        .foregroundStyle(.primaryBlack)
                        .padding(.top, 16)
                    
                    Text(film.genresText)
                        .font(.regular14)
                        .foregroundStyle(.gray7A)
                        .padding(.top, 4)
                    
                    Spacer()
                    
                    HStack {
                        Text(film.displayDate)
                            .font(.regular14)
                            .foregroundStyle(.gray7A)
                        
                        Spacer()
                        
                        Text(film.displayRuntime)
                            .font(.regular14)
                            .foregroundStyle(.gray3C)
                    }
                    .padding(.bottom, 4)
                }
                .padding(.top, 60)
            }
            .padding(.top, -60)
            .padding(.horizontal, 16)
        }
    }
    
    private func body(film: FilmData) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            if let tagline = film.tagline {
                HStack {
                    Text(tagline)
                        .italic()
                        .font(.system(size: 15))
                        .foregroundStyle(.gray7A)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 40)
            }
            
            if let overview = film.overview {
                VStack(alignment: .leading, spacing: 8) {
                    subTitle(text: "Overview")
                    
                    Text(overview)
                        .font(.regular16)
                        .foregroundStyle(.primaryBlack)
                        .lineSpacing(5)
                        .padding(.horizontal, 20)
                }
            }
            
            if let directors = film.credits?.director {
                if directors.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        subTitle(text: "Director")
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(directors) { director in
                                    NavigationLink(destination: PersonDetailView(id: director.id)) {
                                        DirectorCard(name: director.name, profileURL: director.profileURL)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            
            if let casts = film.credits?.cast {
                if casts.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        subTitle(text: "Cast")
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(casts) { cast in
                                    NavigationLink(destination: PersonDetailView(id: cast.id)) {
                                        CastCard(cast: cast)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            
            if let videos = film.videos?.results {
                if videos.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        subTitle(text: "Videos")
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(videos) { video in
                                    if let youtubeURL = video.youtubeURL {
                                        Link(destination: youtubeURL) {
                                            VideoCard(thumbnailURL: video.youtubeThumbnailURL, title: video.name)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            
            if let similar = film.similar?.results {
                if similar.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        subTitle(text: "Similar films")
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(similar) { film in
                                    NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                        FilmCard(film: film)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            
            if let recommendations = film.recommendations?.results {
                if recommendations.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        subTitle(text: "Also you might like...")
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(recommendations) { film in
                                    NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                        FilmCard(film: film)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
        }
    }
    
    private func subTitle(text: String) -> some View {
        Text(text)
            .font(.semibold17)
            .foregroundStyle(.primaryBlack)
            .frame(height: 24)
            .padding(.horizontal, 20)
    }
    
    static func mainText(text: String) -> some View {
        Text(text)
            .font(.regular14)
            .foregroundStyle(.primaryBlack)
            .frame(width: 96, alignment: .leading)
            .multilineTextAlignment(.leading)
    }
    
    static func subText(text: String) -> some View {
        Text(text)
            .font(.regular12)
            .foregroundStyle(.gray7A)
            .frame(width: 96, alignment: .leading)
            .multilineTextAlignment(.leading)
    }

    struct CastCard: View {
        let cast: FilmData.CreditResponse.Cast
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ProfileImage(imageURL: cast.profileURL)
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 104, height: 96)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        mainText(text: cast.name ?? "N/A")
                            .padding(.top, 8)
                        
                        subText(text: cast.character ?? "N/A")
                        
                        Spacer()
                    }
                    .frame(height: 96)
                    .padding(.horizontal, 4)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
        }
    }
    
    struct FilmCard: View {
        let film: FilmData
        
        var body: some View {
            VStack(spacing: 0) {
                ProfileImage(imageURL: film.posterURL)
                
                VStack(alignment: .leading, spacing: 4) {
                    mainText(text: film.displayTitle)
                    
                    Spacer()
                    
                    subText(text: film.yearText)
                }
                .frame(width: 96, height: 80)
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .background(Rectangle().foregroundStyle(.white).frame(width: 104))
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
        }
    }
}

#Preview {
    FilmDetailView(filmId: 157370)
}

struct DirectorCard: View {
    let name: String?
    let profileURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileImage(imageURL: profileURL)
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 104, height: 88)
                
                VStack(alignment: .leading, spacing: 4) {
                    FilmDetailView.mainText(text: name ?? "N/A")
                        .padding(.top, 8)
                    
                    Spacer()
                }
                .frame(height: 88)
                .padding(.horizontal, 4)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
    }
}

struct VideoCard: View {
    let thumbnailURL: URL?
    let title: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                CachedAsyncImage(url: thumbnailURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Utils.placeholderColor
                    }
                }
                .scaledToFill()
                .frame(width: 270, height: 150, alignment: .center)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(4)
                .shadow(radius: 4)
                
                ZStack {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.clear)
                        .background(.regularMaterial)
                    
                    Image(systemName: "play.fill")
                        .foregroundStyle(.white)
                }
                .clipShape(Circle())
            }
            
            Text(title ?? "N/A")
                .font(.regular14)
                .foregroundStyle(.primaryBlack)
                .frame(width: 262, height: 20, alignment: .leading)
                .lineLimit(1)
        }
        .frame(width: 270)
    }
}

//struct FilmDetailListView: View {
//    let film: FilmData
//    let similarFilms: [FilmData]?
//    let recommendationFilms: [FilmData]?
//    
//    @State private var selectedTrailer: FilmVideo?
//    
//    @State var isShowingSheet = false
//    
//    @Binding var isShowingAddToast: Bool
//    @Binding var isShowingRemoveToast: Bool
//    @Binding var isShowingSuccessToast: Bool
//    
//    @State var isAlreadyOnList = false
//        
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            Color("Blue").ignoresSafeArea()
//            LazyVStack(alignment: .leading) {
//                ZStack(alignment: .bottomTrailing) {
//                    FilmDetailImage(imageURL: self.film.backdropURL)
//                    FilmRatingCircle(value: film.voteAverage * 10)
//                        .offset(x: -16, y: -16)
//                }
//                HStack {
//                    FilmPosterImage(imageURL: self.film.posterURL)
//                        .shadow(radius: 4)
//                        .offset(y: -50)
//                        .padding(.bottom, -50)
//                        .padding(.leading, 16)
//                        .padding(.trailing, 8)
//                    VStack(alignment: .leading, spacing: 8) {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(film.title)
//                                .font(.system(size: 22, weight: .black))
//                            Text("\(film.yearText) · \(film.durationText)\(film.adultText)")
//                                .font(.system(size: 16, weight: .semibold))
//                            Text(film.genreText)
//                                .lineLimit(1)
//                                .font(.system(size: 16, weight: .light))
//                                .padding(.top, -6)
//                        }
//                        
//                        HStack(spacing: 12) {
//                            if film.netflixSearchURL != nil {
//                                Link(destination: film.netflixSearchURL!) {
//                                    ZStack {
//                                        RoundedRectangle(cornerRadius: 4)
//                                            .foregroundColor(.black)
//                                            .frame(width: 30, height: 30)
//                                        Image("netflix")
//                                            .resizable()
//                                            .frame(width: 22, height: 40)
//                                            .scaledToFit()
//                                    }
//                                }
//                            }
//                            Spacer()
//                            if !isAlreadyOnList {
//                                Image(systemName: "text.badge.plus")
//                                    .onTapGesture {
//                                        self.saveData(filmID: film.id, posterURL: film.posterURL)
//                                        isAlreadyOnList.toggle()
//                                        isShowingAddToast = true
//                                    }
//                            } else {
//                                Image(systemName: "text.badge.checkmark")
//                                    .onTapGesture {
//                                        self.removeData(filmID: film.id)
//                                        isAlreadyOnList.toggle()
//                                        isShowingRemoveToast = true
//                                    }
//                            }
//                            Image(systemName: "plus.bubble.fill")
//                                .offset(y: 2)
//                                .onTapGesture {
//                                    isShowingSheet.toggle()
//                                }
//                        }
//                        .padding(.top, 8)
//                        .font(.system(size: 22))
//                        .foregroundColor(Color("Red"))
//                    }
//                    .padding(.trailing, 8)
//                    .foregroundColor(.white)
//                }
//                
//                VStack(alignment: .leading) {
//                    if !film.overview.isEmpty {
//                        Text("Overview")
//                            .font(.system(size: 18, weight: .black))
//                            .foregroundColor(Color("Red"))
//                            .padding(.bottom, 8)
//                            .padding(.horizontal, 16)
//                        Text(film.overview)
//                            .padding(.bottom, 16)
//                            .padding(.horizontal, 16)
//                    }
//
//                    if film.directors != nil && film.directors!.count > 0 {
//                        Text("Director")
//                            .font(.system(size: 18, weight: .black))
//                            .foregroundColor(Color("Red"))
//                            .padding(.bottom, 8)
//                            .padding(.horizontal, 16)
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            LazyHStack(spacing: 16) {
//                                ForEach(film.directors!){ director in
//                                    NavigationLink(destination: PersonDetailView(id: director.id)) {
//                                        FilmCastCard(name: director.name, character: nil, profileURL: director.profileURL)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 16)
//                            .frame(height: 225)
//                        }
//                        .padding(.bottom, 16)
//                    }
//                    
//                    if film.cast != nil && film.cast!.count > 0 {
//                        Text("Cast")
//                            .font(.system(size: 18, weight: .black))
//                            .foregroundColor(Color("Red"))
//                            .padding(.bottom, 8)
//                            .padding(.horizontal, 16)
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            LazyHStack(spacing: 16) {
//                                ForEach(film.cast!.prefix(10)){ cast in
//                                    NavigationLink(destination: PersonDetailView(id: cast.id)) {
//                                        FilmCastCard(name: cast.name, character: cast.character, profileURL: cast.profileURL)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 16)
//                            .frame(height: 245)
//                        }
//                        .padding(.bottom, 16)
//                    }
//                }
//                .frame(maxHeight: .infinity)
//                .padding(.top, 8)
//                .minimumScaleFactor(1)
//                .multilineTextAlignment(.leading)
//                .foregroundColor(.white)
//                .font(.system(size: 16, weight: .regular))
//                
//                if film.videos != nil && film.videos!.results.count > 0 {
//                    Text("Videos")
//                        .font(.system(size: 18, weight: .black))
//                        .foregroundColor(Color("Red"))
//                        .padding(.bottom, 8)
//                        .padding(.horizontal, 16)
//                    
//                    YoutubeCarouselView(videos: film.videos!.results)
//                        .padding(.bottom, 16)
//                }
//                
//                if similarFilms != nil && similarFilms!.count > 0 {
//                    Text("Similar films")
//                        .font(.system(size: 18, weight: .black))
//                        .foregroundColor(Color("Red"))
//                        .padding(.bottom, 8)
//                        .padding(.leading, 16)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(spacing: 16) {
//                            ForEach(similarFilms!) { film in
//                                NavigationLink(destination: FilmDetailView(filmId: film.id)) {
//                                    RecommendationPosterView(film: film, width: (UIScreen.main.bounds.size.width - 32) / 2.5, rank: nil, color: Color("Blue"), fontSize: 20)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 16)
//                        .frame(height: (UIScreen.main.bounds.size.width - 32) / 2.5 / 2 * 3 + 20)
//                    }
//                    .padding(.bottom, 16)
//                }
//                
//                if recommendationFilms != nil && recommendationFilms!.count > 0 {
//                    Text("Also you might like...")
//                        .font(.system(size: 18, weight: .black))
//                        .foregroundColor(Color("Red"))
//                        .padding(.bottom, 8)
//                        .padding(.leading, 16)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(spacing: 16) {
//                            ForEach(recommendationFilms!) { film in
//                                NavigationLink(destination: FilmDetailView(filmId: film.id)) {
//                                    RecommendationPosterView(film: film, width: (UIScreen.main.bounds.size.width - 32) / 2.5, rank: nil, color: Color("Blue"), fontSize: 20)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 16)
//                        .frame(height: (UIScreen.main.bounds.size.width - 32) / 2.5 / 2 * 3 + 20)
//                    }
//                }
//            }
//            .sheet(isPresented: $isShowingSheet, content: {
//                AddFilmView(isShowingSheet: $isShowingSheet, isShowingSuccessToast: $isShowingSuccessToast, selectedURL: film.posterURL, title: film.title, id: String(film.id), isSelected: true, genres: film.genres?.prefix(3).map { Constants.shared.genreDictionary[$0.id] ?? 0 } ?? [])
//            })
//            .lineSpacing(5)
//            .ignoresSafeArea()
//            .padding(.bottom, 100)
//        }
//        .onAppear {
//            fetchListState(filmID: film.id)
//        }
//    }
//    
//    private func saveData(filmID: Int, posterURL: URL) {
//        var savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
//        savedDictionary[String(filmID)] = posterURL.absoluteString
//        UserDefaults.standard.set(savedDictionary, forKey: "ToWatchFilms")
//    }
//    
//    private func removeData(filmID: Int) {
//        var savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
//        savedDictionary[String(filmID)] = nil
//        UserDefaults.standard.set(savedDictionary, forKey: "ToWatchFilms")
//    }
//    
//    private func fetchListState(filmID: Int) {
//        let savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
//        let result = savedDictionary[String(filmID)] != nil
//        
//        if result { isAlreadyOnList = true }
//        else { isAlreadyOnList = false }
//    }
//}
