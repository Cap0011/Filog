//
//  WatchListView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/09/04.
//

import CachedAsyncImage
import SwiftUI

struct WatchListView: View {
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 2), count: 3)
    
    @State private var dictionary = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("total \(dictionary.count) films")
                    .font(.regular15)
                    .foregroundStyle(.gray7A)
                    .frame(height: 22)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            if dictionary.isEmpty {
                Spacer()
                
                Text("Nothing here yet")
                    .font(.regular15)
                    .foregroundStyle(.primaryBlack)
                    .frame(height: 24)
                
                Text("Add some films you want to watch next!")
                    .font(.regular15)
                    .foregroundStyle(.primaryBlack)
                    .frame(height: 24)
                
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(Array(dictionary.keys), id: \.self) { id in
                            if let intId = Int(id) {
                                WatchListPosterCard(filmID: intId, posterURL: URL(string: dictionary[id] ?? ""))
                            }
                        }
                    }
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.top, 8)
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            dictionary = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Watch List")
                    .foregroundStyle(.primaryBlack)
                    .font(.semibold20)
            }
        }
    }
}

struct WatchListPosterCard: View {
    let filmID: Int
    let posterURL: URL?
    
    var body: some View {
        NavigationLink(destination: FilmDetailView(filmId: self.filmID)) {
            CachedAsyncImage(url: posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default: Utils.placeholderColor
                }
            }
            .aspectRatio(2/3, contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width / 3)
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
