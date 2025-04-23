//
//  SearchResultView.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import SwiftUI
import CachedAsyncImage

struct SearchResultView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var filmViewModel: SearchViewModel<FilmData>
    @StateObject var showViewModel = SearchViewModel<Show>()
    @StateObject var peopleViewModel = SearchViewModel<Person>()
    
    private let items = ["Films", "TV Shows", "People"]
    
    @State private var width: CGFloat = 350
    @State private var offset = 0
    @State private var selection = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Utils.backButton
                    .padding(.leading, 4)
                
                searchButton
                    .padding(.trailing, 20)
            }
            .padding(.top, 24)
            .onTapGesture {
                self.presentationMode.wrappedValue.dismiss()
            }
            
            selectionBar
                .padding(.top, 40)
            
            TabView(selection: $selection) {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(filmViewModel.searchResults) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                ContentResultRow(title: film.displayTitle, year: film.yearText, posterURL: film.posterURL)}
                        }
                    }
                    .padding(.top, 16)
                }
                .scrollIndicators(.hidden)
                .tag(0)
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(showViewModel.searchResults) { show in
                            ContentResultRow(title: show.name, year: show.year, posterURL: show.posterURL)
                        }
                    }
                    .padding(.top, 24)
                }
                .scrollIndicators(.hidden)
                .tag(1)
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(peopleViewModel.searchResults) { person in
                            PersonResultRow(person: person)
                        }
                    }
                    .padding(.top, 24)
                }
                .scrollIndicators(.hidden)
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .task {
            peopleViewModel.searchText = filmViewModel.searchText
            showViewModel.searchText = filmViewModel.searchText
        }
        .onChange(of: selection) { value in
            withAnimation {
                offset = (Int(width) - 40) / 3 * value
            }
        }
        .readSize { size in
            width = size.width
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
                
                Text(filmViewModel.searchText)
                    .font(.regular16)
                    .foregroundStyle(.primaryBlack)
                    
                Spacer()
            }
            .padding(.horizontal, 12)
        }
    }
    
    var selectionBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .frame(width: (width - 40) / 3, height: 24)
                        .foregroundStyle(index == selection ? .primaryBlack : .graya7)
                        .font(index == selection ? .medium18 : .regular18)
                        .onTapGesture {
                            selection = index
                        }
                }
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 2)
                    .foregroundStyle(.grayf4)
                
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: (width - 40) / 3, height: 3)
                    .foregroundStyle(.primaryBlack)
                    .offset(x: CGFloat(offset))
            }
        }
        .padding(.horizontal, 20)
    }
    
    struct PersonResultRow: View {
        let person: Person
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    CachedAsyncImage(url: person.profileURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Utils.placeholderColor
                        }
                    }
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(width: 50)
                    .cornerRadius(4)
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(person.name)
                            .font(.medium16)
                            .foregroundStyle(.primaryBlack)
                            .frame(height: 22)
                            .lineLimit(1)
                        
                        HStack(spacing: 8) {
                            Text(person.knownForDepartment)
                                .foregroundStyle(.primaryBlack)
                                .lineLimit(1)
                            
                            Text("·")
                                .foregroundStyle(.gray7A)
                            
                            Text(person.knownFor?.map { $0.displayTitle }.joined(separator: ", ") ?? "")
                                .foregroundStyle(.gray7A)
                                .lineLimit(1)
                        }
                        .font(.regular14)
                        .frame(height: 20)
                    }
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.grayf4)
                    .padding(.horizontal, -4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
    
    struct ContentResultRow: View {
        let title: String
        let year: String
        let posterURL: URL?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    CachedAsyncImage(url: posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Utils.placeholderColor
                        }
                    }
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(width: 50)
                    .cornerRadius(4)
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.medium16)
                            .foregroundStyle(.primaryBlack)
                            .frame(height: 22)
                            .lineLimit(1)
                        
                        Text(year)
                            .font(.regular14)
                            .foregroundStyle(.gray7A)
                            .frame(height: 20)
                    }
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.grayf4)
                    .padding(.horizontal, -4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}

#Preview {
    SearchResultView(filmViewModel: SearchViewModel<FilmData>())
}
