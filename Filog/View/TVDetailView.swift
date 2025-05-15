//
//  TVDetailView.swift
//  Filog
//
//  Created by Jiyoung Park on 5/4/25.
//

import SwiftUI
import CachedAsyncImage

struct TVDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let showId: Int
    
    @StateObject private var showViewModel = DetailViewModel<Show>()

    var body: some View {
        ScrollView(.vertical) {
            if let show = showViewModel.detail {
                VStack(alignment: .leading, spacing: 0) {
                    header(show: show)
                    
                    body(show: show)
                }
                .padding(.bottom, 100)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Utils.backButton
                    .padding(.vertical, 8)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .background(.white)
        .task {
            showViewModel.id = showId
        }
    }
    
    private func header(show: Show) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                ParallaxHeaderImage(imageURL: show.backdropURL)

                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        RatingCircle(value: (show.voteAverage ?? 0) * 10)
                            .padding(.trailing, 16)
                            .padding(.bottom, 12)
                    }
                }
            }
            
            HStack(alignment: .bottom, spacing: 12) {
                PosterImage(imageURL: show.posterURL)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(show.displayTitle)
                        .font(.semibold18)
                        .foregroundStyle(.primaryBlack)
                        .padding(.top, 16)
                    
                    Text(show.genresText)
                        .font(.regular14)
                        .foregroundStyle(.gray7A)
                        .padding(.top, 4)
                    
                    Spacer()
                    
                    Text("\(show.displayFirstDate) ~ \(show.displayLastDate)")
                        .font(.regular14)
                        .foregroundStyle(.gray7A)
                        .padding(.bottom, 4)
                }
                .padding(.top, 60)
            }
            .padding(.top, -60)
            .padding(.horizontal, 16)
        }
    }
    
    private func body(show: Show) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            if let tagline = show.tagline {
                HStack {
                    Text(tagline)
                        .italic()
                        .font(.system(size: 15))
                        .foregroundStyle(.gray7A)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 40)
            }
            
            if let overview = show.overview {
                VStack(alignment: .leading, spacing: 8) {
                    subTitle(text: "Overview")
                    
                    Text(overview)
                        .font(.regular16)
                        .foregroundStyle(.primaryBlack)
                        .lineSpacing(5)
                        .padding(.horizontal, 20)
                }
            }
            
            if let seasons = show.seasons {
                VStack(alignment: .leading, spacing: 8) {
                    subTitle(text: "Seasons")
                    
                    HStack {
                        Spacer()
                        
                        Text("\(seasons.count) seasons, \(seasons.compactMap { $0.episodeCount }.reduce(0, +)) episodes")
                            .font(.regular16)
                            .foregroundStyle(.primaryBlue)
                            .padding(.horizontal, 24)
                    }
                    
                    TabView {
                        ForEach(seasons, id: \.id) { season in
                            VStack {
                                SeasonCard(season: season)
                                    .padding(.horizontal, 16)
                                
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 230)
                    .tabViewStyle(.page)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
            }
            
            if let directors = show.createdBy {
                if directors.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        subTitle(text: "Creator")
                        
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
            
            if let casts = show.aggregateCredits?.cast {
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
            
            if let videos = show.videos?.results {
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
            
            if let language = show.originalLanguage {
                VStack(alignment: .leading, spacing: 8) {
                    subTitle(text: "Original language")
                    
                    Text(Locale(identifier: "en").localizedString(forIdentifier: language) ?? language)
                        .foregroundStyle(.primaryBlack)
                        .font(.regular16)
                        .frame(height: 22)
                        .padding(.horizontal, 20)
                }
            }
            
            if let country = show.originCountry {
                VStack(alignment: .leading, spacing: 8) {
                    subTitle(text: "Original country")
                    
                    Text(country.joined(separator: ", "))
                        .foregroundStyle(.primaryBlack)
                        .font(.regular16)
                        .frame(height: 22)
                        .padding(.horizontal, 20)
                }
            }
            
            if let networks = show.networks {
                VStack(alignment: .leading, spacing: 20) {
                    subTitle(text: "Networks")
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 24) {
                            ForEach(networks, id: \.id) { network in
                                CachedAsyncImage(url: network.logoURL, transaction: Transaction(animation: .easeInOut)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                        default: Utils.placeholderColor
                                    }
                                }
                                .scaledToFit()
                                .frame(height: 60, alignment: .center)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            
            VStack(alignment: .leading, spacing: 24) {
                if let similar = show.similar?.results {
                    if similar.count > 0 {
                        VStack(alignment: .leading, spacing: 0) {
                            subTitle(text: "Similar shows")
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 12) {
                                    ForEach(similar) { show in
                                        NavigationLink(destination: TVDetailView(showId: show.id)) {
                                            ShowCard(show: show)
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
                
                if let recommendations = show.recommendations?.results {
                    if recommendations.count > 0 {
                        VStack(alignment: .leading, spacing: 0) {
                            subTitle(text: "Also you might like...")
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 12) {
                                    ForEach(recommendations) { show in
                                        NavigationLink(destination: TVDetailView(showId: show.id)) {
                                            ShowCard(show: show)
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
            .padding(.top, 50)
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
    
    struct SeasonCard: View {
        let season: Show.Season
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    CachedAsyncImage(url: season.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Utils.placeholderColor.frame(width: 104, height: 156, alignment: .center)
                        }
                    }
                    .frame(width: 104, height: 156, alignment: .center)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    
                    if let voteAverage = season.voteAverage {
                        RatingCircle(value: voteAverage * 10, size: 34, font: .semibold14)
                            .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(season.name ?? "Season \(season.seasonNumber ?? 0)")
                        .font(.medium17)
                        .foregroundStyle(.primaryBlack)
                        .padding(.top, 8)
                    
                    HStack {
                        if let airDate = season.airDate {
                            Text(airDate.replacingOccurrences(of: "-", with: "."))
                                .font(.regular14)
                                .foregroundStyle(.graya7)
                        }
                        
                        Spacer()
                        
                        if let episodeCount = season.episodeCount {
                            Text("\(episodeCount) episodes")
                                .font(.regular14)
                                .foregroundStyle(.gray7A)
                        }
                    }
                    .padding(.top, 8)
                    
                    if let overview = season.overview {
                        Text(overview)
                            .font(.regular14)
                            .foregroundStyle(.primaryBlack)
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .lineSpacing(2)
                            .padding(.top, 16)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white).shadow(color: .black.opacity(0.06), radius: 8))
        }
    }

    struct CastCard: View {
        let cast: Show.CreditResponse.Cast
        
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
                        
                        Text(cast.characters)
                            .foregroundStyle(.gray3C)
                            .font(.regular12)
                            .frame(width: 96, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        subText(text: "\(cast.totalEpisodeCount ?? 0) episodes")
                            .padding(.bottom, 8)
                    }
                    .frame(height: 96)
                    .padding(.horizontal, 4)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
        }
    }

    struct ShowCard: View {
        let show: Show
        
        var body: some View {
            VStack(spacing: 0) {
                ProfileImage(imageURL: show.posterURL)
                
                VStack(alignment: .leading, spacing: 4) {
                    mainText(text: show.displayTitle)
                    
                    Spacer()
                    
                    subText(text: show.year)
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
    TVDetailView(showId: 42009)
}
