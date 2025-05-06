//
//  WatchedView.swift
//  Filog
//
//  Created by Jiyoung Park on 3/25/25.
//

import SwiftUI

struct WatchedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Film.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Film.createdAt, ascending: true)]
    ) var films: FetchedResults<Film>
    @StateObject private var toastManager = ToastManager.shared
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 3)
    private let sortBy = ["Newest Reviews", "Oldest Reviews", "Recently Watched", "Earliest Watched"]
    
    @State private var selectedIndex = 0
    @State private var isShowingSheet = false
    @State private var sortedFilms = [Film]()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(alignment: .bottom) {
                    sortMenuCapsule
                        .onTapGesture {
                            isShowingSheet.toggle()
                        }
                    
                    Spacer()
                    
                    Text("total \(films.count) reviews")
                        .font(.regular15)
                        .foregroundStyle(.gray7A)
                        .frame(height: 22)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                if films.isEmpty {
                    Spacer()
                    
                    Text("You haven't left a review yet.")
                        .font(.regular15)
                        .foregroundStyle(.primaryBlack)
                        .frame(height: 24)
                    
                    Text("Tap the plus button above to write one!")
                        .font(.regular15)
                        .foregroundStyle(.primaryBlack)
                        .frame(height: 24)
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(sortedFilms, id: \.id) { film in
                                if let poster = film.poster, let uiImage = UIImage(data: poster), let title = film.title, let id = Int(film.id ?? "") {
                                    NavigationLink(destination: FilmDetailView(filmId: id)) {
                                        ReviewThumnailView(image: Image(uiImage: uiImage), title: title, iconName: film.recommend && film.recommendsub ? "best" : (film.recommend ? "like" : "bad"))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .toast(message: ToastType.save.message, isShowing: $toastManager.isShowingSaveToast, duration: Toast.short)
            .onAppear {
                updateSortedFilms()
            }
            .onChange(of: selectedIndex) { newIndex in
                updateSortedFilms()
            }
            .padding(.top, 24)
            .background(.white)
            .sheet(isPresented: $isShowingSheet) {
                ZStack {
                    Color.white.ignoresSafeArea()
                    sortMenu
                }
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.35)])
                    .background(.white)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("Filog")
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Watched")
                        .foregroundStyle(.primaryBlack)
                        .font(.semibold20)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: FindView()) {
                        Image(systemName: "plus")
                            .foregroundStyle(.primaryBlue)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
    
    var sortMenuCapsule: some View {
        HStack(spacing: 8) {
            Text(sortBy[selectedIndex])
                .font(.medium16)
            Image(systemName: "chevron.down")
        }
        .foregroundStyle(.primaryBlack)
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white).frame(height: 38).shadow(color: .black.opacity(0.04), radius: 8, x: 2, y: 2))
    }
    
    var sortMenu: some View {
        VStack(spacing: 24) {
            ForEach(sortBy.indices, id: \.self) { index in
                ZStack(alignment: .leading) {
                    if selectedIndex == index {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.primaryBlack)
                            .offset(x: -24)
                    }
                    Text(sortBy[index])
                }
                .frame(height: 20)
                .foregroundStyle(selectedIndex == index ? .primaryBlack : .gray7A)
                .font(selectedIndex == index ? .medium16 : .regular16)
                .onTapGesture {
                    selectedIndex = index
                    isShowingSheet = false
                }
            }
        }
        .background(.white)
    }
    
    func updateSortedFilms() {
        switch selectedIndex {
        case 0: // "Newest Reviews"
            sortedFilms = films.sorted {
                guard let first = $0.createdAt, let second = $1.createdAt else { return $0.createdAt != nil }
                return first > second
            }
        case 1: // "Oldest Reviews"
            sortedFilms = films.sorted {
                guard let first = $0.createdAt, let second = $1.createdAt else { return $0.createdAt != nil }
                return first < second
            }
        case 2: // "Recently Watched"
            sortedFilms = films.sorted {
                guard let first = $0.watchedAt, let second = $1.watchedAt else { return $0.watchedAt != nil }
                return first > second
            }
        case 3: // "Earliest Watched"
            sortedFilms = films.sorted {
                guard let first = $0.watchedAt, let second = $1.watchedAt else { return $0.watchedAt != nil }
                return first < second
            }
        default:
            sortedFilms = Array(films)
        }
    }
    
    struct ReviewThumnailView: View {
        let image: Image
        let title: String
        let iconName: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 4, y: 4)
                    .overlay(Image(iconName).padding(8).padding(.bottom, 2), alignment: .bottomTrailing)
                
                Text(title)
                    .font(.regular15)
                    .foregroundStyle(.primaryBlack)
                    .frame(height: 40, alignment: .topLeading)
                    .lineLimit(2)
                    .padding(.horizontal, 6)
            }
        }
    }
}

#Preview {
    WatchedView()
}
