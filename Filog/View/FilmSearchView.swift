//
//  FilmSearchView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI

struct FilmSearchView: View {
    
    @ObservedObject var filmSearchState = FilmSearchState()
    @Binding var isShowingSheet: Bool
    @State private var isSearching = false
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack {
                    SearchBar(isFocusedFirst: true, searchTitle: $filmSearchState.query, isSearching: $isSearching)
                    
                    ScrollView {
                        LoadingView(isLoading: self.filmSearchState.isLoading, error: self.filmSearchState.error) {
                            Task {
                                await self.filmSearchState.search(query: self.filmSearchState.query)
                            }
                        }
                        
                        if self.filmSearchState.films != nil {
                            LazyVStack {
                                ForEach(self.filmSearchState.films!) { film in
                                    NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                        ZStack {
                                            FilmSearchRow(film: film)
                                                .listRowBackground(Color.clear)
                                            Image(systemName: "chevron.forward")
                                                .offset(x: 150)
                                                .foregroundColor(.white)
                                        }
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

