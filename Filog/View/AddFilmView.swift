//
//  AddFilmView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import CachedAsyncImage
import SwiftUI

struct AddFilmView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShowingSheet: Bool
    @Binding var isShowingSuccessToast: Bool
    @State var selectedURL: URL?
    @State var title: String = ""
    @State var id: String = ""

    @State private var showErrorToast = false
    
    @State private var selectedImage: Image?
    @State private var isShowingSearchSheet: Bool = false
    
    @State private var genre: Int = 1
    @State private var review: String = ""
    @State private var recommend: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack {
                    CachedAsyncImage(url: self.selectedURL)  { image in
                        image
                            .resizable()
                            .onAppear {
                                selectedImage = image
                            }
                    } placeholder: {
                        Image("White")
                            .resizable()
                    }
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.size.width / 2 - 24)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 2)
                    .padding(.vertical, 16)
                    .onTapGesture {
                        // Look up film from tmdb
                        isShowingSearchSheet.toggle()
                    }
                    .sheet(isPresented: $isShowingSearchSheet) {
                        ImageSearchView(isShowingSheet: $isShowingSearchSheet, selectedURL: $selectedURL, title: $title, id: $id)
                    }
                    
                    GenreScrollView(selected: $genre, isAllIncluded: false)
                        .padding(.bottom, 16)
                    
                    TextField("Film title", text: $title)
                        .padding(.leading, 16)
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .font(.system(size: 16, weight: .black))
                        .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.white))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                    ZStack(alignment: .topLeading) {
                        if review.isEmpty {
                            Text("How did you find the film?")
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                                .foregroundColor(.white)
                                .opacity(0.4)
                        }
                        
                        TextEditor(text: $review)
                            .padding(.horizontal, 12)
                            .frame(height: 80)
                            .lineSpacing(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.white))
                            .padding(.horizontal, 16)
                    }
                    .font(.system(size: 16, weight: .light))
                    
                    VStack(spacing: 24) {
                        Text("Did you enjoy watching it?")
                            .font(.custom(FontManager.Inconsolata.black, size: 22))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 80) {
                            VStack(spacing: 5) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 40))
                                Text("For sure")
                                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
                            }
                            .foregroundColor(recommend ? Color("Red") : .white)
                            .onTapGesture {
                                recommend = true
                            }
                            
                            VStack(spacing: 5) {
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 40))
                                Text("Not really")
                                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
                            }
                            .foregroundColor(recommend ? .white : Color("Red"))
                            .onTapGesture {
                                recommend = false
                            }
                        }
                    }
                    .padding(.top, 24)
                }
            }
            .toast(message: "Please choose a film", isShowing: $showErrorToast, duration: Toast.short)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.isShowingSheet.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // If incomplete -> toast
                        if title.isEmpty {
                            showErrorToast = true
                        }
                        // If complete -> save
                        else {
                            self.isShowingSheet = false
                            self.isShowingSuccessToast = true
                            addFilm(title: title, review: review, genre: genre, recommend: recommend, poster: selectedImage ?? Image("NoPoster"))
                        }
                    } label: {
                        Text("Save")
                            .font(.system(size: 17, weight: .heavy))
                    }
                }
            }
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
    
    private func addFilm(title: String, review: String, genre: Int, recommend: Bool, poster: Image) {
        let newFilm = Film(context: viewContext)
        newFilm.title = title
        newFilm.recommend = recommend
        newFilm.review = review
        newFilm.genre = Int64(genre)
        newFilm.poster = poster.snapshot().pngData()
        newFilm.id = id
        
        saveContext()
    }
}
