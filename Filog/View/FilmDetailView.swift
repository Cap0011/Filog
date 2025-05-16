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
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var reviews: FetchedResults<Film>
    
    let filmId: Int

    @StateObject private var filmViewModel = DetailViewModel<FilmData>()
    @StateObject private var toastManager = ToastManager.shared
    
    @State private var isAlreadyOnWatchlist = false
    @State private var isAddedToWatchlistToastShowing = false
    @State private var isRemovedFromWatchlistToastShowing = false
    @State private var isDeleteReviewPopupPresented = false
    
    @State private var review: Film?
    
    @State private var width: CGFloat = 0

    var body: some View {
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
        .toast(message: "Added to watchlist!", isShowing: $isAddedToWatchlistToastShowing, duration: Toast.short)
        .toast(message: "Removed from watchlist!", isShowing: $isRemovedFromWatchlistToastShowing, duration: Toast.short)
        .toast(message: ToastType.save.message, isShowing: $toastManager.isShowingSaveToast, duration: Toast.short)
        .popup(isPresented: $isDeleteReviewPopupPresented) {
            DeletePopupView(isPresented: $isDeleteReviewPopupPresented) {
                if let review = review {
                    deleteReview(object: review)
                }
            }
        }
        .task {
            filmViewModel.id = filmId
            isAlreadyOnWatchlist = isAddedToWatchlist(filmID: filmId)
            review = reviews.filter { $0.id == String(filmId) }.first
        }
        .readSize { size in
            width = size.width
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Utils.backButton
                    .padding(.vertical, 8)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func header(film: FilmData) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                ParallaxHeaderImage(imageURL: film.backdropURL)
                
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
            HStack(spacing: 0) {
                ButtonView(title: "Watchlist", imageName: isAlreadyOnWatchlist ? "eye" : "plus")
                    .onTapGesture {
                        if isAlreadyOnWatchlist {
                            removeFromWatchlist(filmID: filmId)
                            print("removeFromWatchlist")
                        } else {
                            addToWatchlist(filmID: filmId, posterURL: film.posterURL)
                            print("addToWatchlist")
                        }
                        isAlreadyOnWatchlist.toggle()
                    }
                
                Spacer()
                
                if let review = review {
                    NavigationLink(destination: EditReviewView(film: film, review: review)) {
                        ButtonView(title: "Edit review", imageName: "square.and.pencil")
                    }
                } else {
                    NavigationLink(destination: EditReviewView(film: film, review: nil)) {
                        ButtonView(title: "Write review", imageName: "square.and.pencil")
                    }
                }
                
                Spacer()
                
                if review != nil {
                    ButtonView(title: "Delete review", imageName: "trash")
                        .onTapGesture {
                            isDeleteReviewPopupPresented.toggle()
                        }
                } else {
                    Color.clear.frame(width: 100, height: 1)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 25)
            .background(.grayf4)
            .padding(.top, 24)
            
            if let review = review {
                VStack(alignment: .leading, spacing: 8) {
                    subTitle(text: "Your Review")
                    
                    if let text = review.review {
                        Text(text)
                            .font(.regular16)
                            .foregroundStyle(.primaryBlack)
                            .lineSpacing(3)
                            .frame(width: max(0, width - 64), alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 12)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.white).shadow(color: .black.opacity(0.04), radius: 6))
                            .padding(.horizontal, 16)
                    }
                    
                    HStack {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Watch date")
                                    .font(.regular14)
                                    .foregroundStyle(.gray3C)
                                
                                Spacer()
                                
                                Text(review.watchedAt?.formattedString(format: "yyyy.MM.dd") ?? "Unknown")
                                    .font(.regular14)
                                    .foregroundStyle(.gray7A)
                            }
                            
                            HStack {
                                Text("Review date")
                                    .font(.regular14)
                                    .foregroundStyle(.gray3C)
                                
                                Spacer()
                                
                                Text(review.watchedAt?.formattedString(format: "yyyy.mm.dd") ?? "Unknown")
                                    .font(.regular14)
                                    .foregroundStyle(.gray7A)
                            }
                        }
                        .frame(width: 163)
                        
                        Spacer()
                        
                        Image("rating\(!review.recommend ? "0" : !review.recommendsub ? "1" : "2")_selected")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 20)
                    
                    Rectangle()
                        .foregroundStyle(.grayf4)
                        .frame(height: 1)
                        .padding(.top, 16)
                        .padding(.horizontal, 15)
                }
            }
            
            if let tagline = film.tagline {
                if !tagline.isEmpty {
                    HStack {
                        Text(tagline)
                            .italic()
                            .font(.system(size: 15))
                            .foregroundStyle(.gray7A)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 24)
                }
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
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    private func deleteReview(object: Film) {
        viewContext.delete(object)
        saveContext()
    }
    
    private func addToWatchlist(filmID: Int, posterURL: URL?) {
        var savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        savedDictionary[String(filmID)] = posterURL?.absoluteString
        UserDefaults.standard.set(savedDictionary, forKey: "ToWatchFilms")
        isAddedToWatchlistToastShowing.toggle()
    }
    
    private func removeFromWatchlist(filmID: Int) {
        var savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        savedDictionary[String(filmID)] = nil
        UserDefaults.standard.set(savedDictionary, forKey: "ToWatchFilms")
        isRemovedFromWatchlistToastShowing.toggle()
    }
    
    private func isAddedToWatchlist(filmID: Int) -> Bool {
        let savedDictionary: [String: String] = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        return savedDictionary[String(filmID)] != nil
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
    
    struct ButtonView: View {
        let title: String
        let imageName: String
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: imageName)
                    .frame(height: 30)
                
                Text(title)
                    .font(.regular14)
            }
            .foregroundStyle(.primaryBlue)
            .frame(width: 100)
            .contentShape(Rectangle())
        }
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
    
    struct DeletePopupView: View {
        @Binding var isPresented: Bool
        let onDelete: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Delete")
                    .font(.semibold18)
                    .foregroundStyle(.primaryBlack)
                
                Text("Are you sure you want to\n delete this item?")
                    .font(.regular16)
                    .foregroundStyle(.gray3C)
                    .padding(.top, 12)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 0) {
                    Text("Cancel")
                        .font(.medium16)
                        .foregroundStyle(.gray3C)
                        .frame(width: 128, height: 43)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isPresented = false
                        }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.primaryBlue)
                            .frame(width: 128, height: 43)
                        
                        Text("Delete")
                            .font(.medium16)
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        isPresented = false
                        onDelete()
                    }
                }
                .padding(.top, 30)
            }
            .padding(.top, 30)
            .padding(.horizontal, 16)
            .padding(.bottom, 17)
            .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white))
            .padding(.horizontal, 48)
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
