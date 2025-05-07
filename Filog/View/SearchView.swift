//
//  SearchView.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = SearchViewModel<FilmData>()
    @StateObject private var historyManager = SearchHistoryManager.shared
    
    @State private var shouldNavigate = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Utils.backButton
                    .padding(.leading, 4)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                MySearchBar(text: $viewModel.searchText, placeholder: "Look up films and people")
                    .submitLabel(.search)
                    .onSubmit {
                        historyManager.addHistory(viewModel.searchText)
                        // TODO: Move to SearchResultView
                        shouldNavigate = true
                    }
                    .padding(.trailing, 20)
            }
            .padding(.top, 24)
            
            if viewModel.searchText.isEmpty {
                searchHistorySection
                    .padding(.top, 24)
                
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.searchResults) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                FilmSearchRow(film: film, query: viewModel.searchText)
                                    .onTapGesture {
                                        viewModel.searchText = film.displayTitle
                                        historyManager.addHistory(viewModel.searchText)
                                        // TODO: Move to SearchResultView
                                        shouldNavigate = true
                                    }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 24)
            }
            
            NavigationLink(
                destination: SearchResultView(filmViewModel: viewModel),
                isActive: $shouldNavigate
            ) {
                EmptyView()
            }
        }
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
    }

    var searchHistorySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                Text("Recent Searches")
                    .font(.medium16)
                    .frame(height: 24)
                
                Spacer()
                
                if !historyManager.history.isEmpty {
                    Text("Clear all")
                        .font(.regular14)
                        .foregroundStyle(.primaryBlue)
                        .onTapGesture {
                            historyManager.clearHistory()
                        }
                }
            }
            .padding(.horizontal, 20)
            
            if historyManager.history.isEmpty {
                Text("Your recent searches will appear here.")
                    .font(.regular14)
                    .foregroundStyle(.graya7)
                    .padding(.top, 12)
                    .padding(.leading, 20)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(historyManager.history.indices, id: \.self) { index in
                            historyCapsule(text: historyManager.history[index], index: index)
                                .onTapGesture {
                                    viewModel.searchText = historyManager.history[index]
                                    // TODO: Move to SearchResultView
                                    shouldNavigate = true
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden, axes: .horizontal)
            }
        }
        .foregroundStyle(.primaryBlack)
    }
    
    struct historyCapsule: View {
        @StateObject private var historyManager = SearchHistoryManager.shared
        
        let text: String
        let index: Int
        
        var body: some View {
            HStack(spacing: 6) {
                Text(text)
                    .font(.regular14)
                
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundStyle(.graya7)
                    .onTapGesture {
                        historyManager.deleteHistory(at: index)
                    }
            }
            .padding(.horizontal, 12)
            .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white).shadow(color: .black.opacity(0.04), radius: 2, x: 2, y: 2).frame(height: 38))
            .frame(height: 62)
        }
    }
}

#Preview {
    SearchView()
}
