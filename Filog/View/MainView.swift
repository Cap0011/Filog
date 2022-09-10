//
//  MainView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ])
    
    private var films: FetchedResults<Film>
    @State private var resultFilms = [FetchedResults<Film>.Element]()
    @State private var selectedFilm: FetchedResults<Film>.Element?
    
    @State private var isShowingSheet = false
    @State var isShowingSuccessToast = false
    @State var isShowingEditToast = false
    @State private var isShowingEditSheet = false
    @State private var isShowingActionSheet = false
    @State private var isShowingDetailSheet = false

    @State var searchTitle = ""
    @State var isSearching = false
    
    @State private var genre = 0
    
    @State var refresh: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                VStack(spacing: 16) {
                    SearchBar(isFocusedFirst: false, searchTitle: $searchTitle, isSearching: $isSearching)
                            .padding(.top, 10)
                        GenreScrollView(selected: $genre)
                        ScrollView(showsIndicators: false) {
                            HStack(alignment: .top) {
                                ForEach(0...1, id: \.self) { column in
                                    LazyVStack(spacing: 16) {
                                        ForEach(0..<resultFilms.count, id: \.self) { idx in
                                            if idx % 2 == column {
                                                MainCardView(film: resultFilms[idx])
                                                    .confirmationDialog(selectedFilm?.title ?? "", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                                                        Button("See film info", role: .none) {
                                                            // Open Detail View
                                                            isShowingDetailSheet.toggle()
                                                        }
                                                        Button("Edit", role: .none) {
                                                            // Open Edit Sheet
                                                            isShowingEditSheet.toggle()
                                                        }
                                                        Button("Delete", role: .destructive) {
                                                            // Delete
                                                            deleteFilm(object: selectedFilm!)
                                                            Constants.shared.films = films.filter{ $0.genre >= 0 }
                                                        }
                                                        Button("Cancel", role: .cancel) {
                                                            isShowingActionSheet = false
                                                        }
                                                    }
                                                    .onTapGesture {
                                                        selectedFilm = resultFilms[idx]
                                                        isShowingActionSheet = true
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .simultaneousGesture(DragGesture().onChanged({ gesture in
                            withAnimation{
                                UIApplication.shared.dismissKeyboard()
                            }
                        }))
                    }
                .onAppear {
                    resultFilms = films.filter{ $0.genre >= 0 }
                    Constants.shared.films = films.filter{ $0.genre >= 0 }
                }
                .onChange(of: genre) { genre in
                    if genre == 0 { resultFilms = films.filter{ $0.genre >= 0 } }
                    else { resultFilms = films.filter{ Utils.decodeGenres(number: Int($0.genre) - 1).contains(genre) } }
                    if isSearching && searchTitle != "" { resultFilms = resultFilms.filter{ $0.title!.lowercased().contains(searchTitle.lowercased()) } }
                }
                .onChange(of: searchTitle, perform: { title in
                    if title != "" { resultFilms = films.filter{ $0.title!.lowercased().contains(title.lowercased()) } }
                    else if genre != 0 { resultFilms = films.filter { Utils.decodeGenres(number: Int($0.genre) - 1).contains(genre) } }
                    else { resultFilms = films.filter{ $0.genre >= 0 } }
                })
                .onChange(of: isSearching, perform: { isSearching in
                    if !isSearching {
                        searchTitle = ""
                        if genre == 0 { resultFilms = films.filter{ $0.genre >= 0 } }
                        else { resultFilms = films.filter{ Utils.decodeGenres(number: Int($0.genre) - 1).contains(genre) } }
                    }
                })
                .onChange(of: isShowingSheet, perform: { _ in
                    resultFilms = films.filter{ $0.genre >= 0 }
                    Constants.shared.films = films.filter{ $0.genre >= 0 }
                })
                .onChange(of: isShowingEditSheet, perform: { _ in
                    Constants.shared.films = films.filter{ $0.genre >= 0 }
                })
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Filog")
                            .font(.custom(FontManager.rubikGlitch, size: 20))
                            .foregroundColor(.white)
                            .accessibilityAddTraits(.isHeader)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // Add
                            isShowingSheet.toggle()
                        } label: {
                            Label("Add", systemImage: "plus")
                                .foregroundColor(.white)
                        }
                    }
                }
                .toast(message: "Your review was successfully added!", isShowing: $isShowingSuccessToast, duration: Toast.short)
                .toast(message: "Your review was successfully edited!", isShowing: $isShowingEditToast, duration: Toast.short)
                .sheet(isPresented: $isShowingSheet) {
                    AddFilmView(isShowingSheet: self.$isShowingSheet, isShowingSuccessToast: $isShowingSuccessToast)
                }
                .sheet(isPresented: $isShowingEditSheet) {
                    EditFilmView(isShowingSheet: self.$isShowingEditSheet, isShowingSuccessToast: $isShowingEditToast, film: $selectedFilm)
                }
                .sheet(isPresented: $isShowingDetailSheet) {
                    if selectedFilm != nil {
                        NavigationView {
                            FilmDetailSheetView(filmId: Int(selectedFilm!.id!) ?? 0, isShowingSheet: $isShowingDetailSheet)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
    
    private func deleteFilm(object: Film) {
        viewContext.delete(object)
        saveContext()
    }
}
