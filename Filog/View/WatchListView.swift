//
//  WatchListView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/09/04.
//

import CachedAsyncImage
import SwiftUI

struct WatchListView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var dictionary = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: 16) {
                            ZStack {
                                Text("Watch List")
                                    .foregroundColor(Color("Red"))
                                    .offset(x: 3)
                                
                                Text("Watch List")
                                    .foregroundColor(.white)
                            }
                            .font(.system(size: 24, weight: .black))
                            .padding(.horizontal, 16)
                            .padding(.bottom, 4)
                            
                            if dictionary.count == 0 {
                                VStack(spacing: 8) {
                                    Text("There's no film on your watch list 😢")
                                    Text("Find films on Explore tab or For You tab and add them to your list!")
                                }
                                .font(.system(size: 16, weight: .heavy))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                            } else  {
                                LazyVGrid(columns: columns, spacing: 2) {
                                    ForEach(Array(dictionary.keys), id: \.self) { key in
                                        if Int(key) != nil {
                                            WatchListPosterCard(filmID: Int(key)!, posterURL: URL(string: dictionary[key]!))
                                        }
                                    }
                                }
                            }
                    }
                }
                .padding(.top, 8)
            }
            .navigationBarHidden(true)
            .onAppear {
                dictionary = UserDefaults.standard.dictionary(forKey: "ToWatchFilms") as? [String: String] ?? [:]
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
            .aspectRatio(2/3, contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width / 3)
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
