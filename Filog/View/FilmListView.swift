//
//  FilmListView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

@MainActor
struct FilmListView: View {
    @State private var viewModels = [FilmListViewModel]()
    
    @StateObject private var nowPlayingViewModel = FilmListViewModel(endpoint: .nowPlaying)
    @StateObject private var upcomingViewModel = FilmListViewModel(endpoint: .upcoming)
    @StateObject private var popularViewModel = FilmListViewModel(endpoint: .popular)
    @StateObject private var topRatedViewModel = FilmListViewModel(endpoint: .topRated)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                searchButton
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        ForEach(viewModels, id: \.endpoint) { viewModel in
                            if let films = viewModel.films {
                                FilmCarouselView(title: viewModel.endpoint.text, films: films, imageType: viewModel.endpoint.imageType)
                            } else {
                                loadingView
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
        .task {
            viewModels = [nowPlayingViewModel, upcomingViewModel, popularViewModel, topRatedViewModel]
        }
        .readSize { size in
            Utils.screenWidth = size.width
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
    
    var loadingView: some View {
        HStack {
            Spacer()
            ActivityIndicatorView()
            Spacer()
        }
    }
}

struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
