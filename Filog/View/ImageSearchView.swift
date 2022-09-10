//
//  ImageSearchView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct ImageSearchView: View {
    @ObservedObject var filmSearchState = FilmSearchState()
    
    @Binding var isShowingSheet: Bool
    @Binding var selectedURL: URL?
    @Binding var title: String
    @Binding var id: String
    @Binding var genres: [Int]
    @Binding var isSelected: Bool
    
    @State private var isSearching = false
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack {
                    SearchBar(searchTitle: $filmSearchState.query, isSearching: $isSearching)
                    
                    ScrollView {
                        LoadingView(isLoading: self.filmSearchState.isLoading, error: self.filmSearchState.error) {
                            Task {
                                await self.filmSearchState.search(query: self.filmSearchState.query)
                            }
                        }
                        
                        if self.filmSearchState.films != nil {
                            LazyVStack {
                                ForEach(self.filmSearchState.films!) { film in
                                    FilmSearchRow(film: film)
                                        .listRowBackground(Color.clear)
                                    .onTapGesture {
                                        // Pass posterURL and film title, close this sheet
                                        selectedURL = film.posterURL
                                        title = film.title
                                        id = String(film.id)
                                        if film.genreIds != nil {
                                            genres = Array(film.genreIds!.prefix(3).map { Constants.shared.genreDictionary[$0] ?? 0 })
                                        } else {
                                            genres = []
                                        }
                                        self.isShowingSheet = false
                                        self.isSelected = true
                                    }
                                }
                            }
                        }
                    }
                    .simultaneousGesture(DragGesture().onChanged({ gesture in
                        withAnimation{
                            UIApplication.shared.dismissKeyboard()
                        }
                    }))
                }
                .onAppear {
                    self.filmSearchState.startObserve()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                self.isShowingSheet = false
            }) {
                Text("Cancel")
            })
        }
    }
}
