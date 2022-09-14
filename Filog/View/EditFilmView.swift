//
//  EditFilmView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/29.
//

import SwiftUI

struct EditFilmView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShowingSheet: Bool
    @Binding var isShowingSuccessToast: Bool
    
    @State private var showErrorToast = false

    @State private var filmImage: Image?
    @State private var genres = [Int]()
    @State private var title: String = ""
    @State private var review: String = ""
    @State private var recommend: Bool = true
    @State private var recommendsub: Bool = true
    
    @Binding var film: FetchedResults<Film>.Element?

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack {
                    let image = filmImage ?? Image("NoPoster")
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width / 2 - 24)
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 2)
                        .padding(.top, 16)
                    
                    // Film Title
                    Text(title)
                        .font(.system(size: 24, weight: .black))
                    
                    // Genres
                    HStack(spacing: 16) {
                        ForEach(genres, id: \.self) { genre in
                            SelectedGenreView(idx: genre)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .padding(.top, -4)
                    
                    // Review
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
   
                    // Recommendation
                    VStack(spacing: 24) {
                        Text("Did you enjoy watching it?")
                            .font(.custom(FontManager.Inconsolata.black, size: 22))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 40) {
                            VStack(spacing: 5) {
                                ZStack {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 40))
                                        .offset(x: 26)
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 46))
                                        .foregroundColor(Color("Blue"))
                                        .offset(y: 1)
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 40))
                                }
                                .padding(.trailing, 40)
                                .padding(.bottom, -6)
                                Text("For sure")
                                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
                            }
                            .foregroundColor(recommend && recommendsub ? Color("Red") : .white)
                            .onTapGesture {
                                recommend = true
                                recommendsub = true
                            }
                            
                            VStack(spacing: 5) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 40))
                                Text("Maybe")
                                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
                            }
                            .foregroundColor(recommend && !recommendsub ? Color("Red") : .white)
                            .onTapGesture {
                                recommend = true
                                recommendsub = false
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
                .simultaneousGesture(DragGesture().onChanged({ gesture in
                    withAnimation{
                        UIApplication.shared.dismissKeyboard()
                    }
                }))
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
                            showErrorToast.toggle()
                        }
                        // If complete -> save
                        else {
                            self.isShowingSheet = false
                            editFilm(review: review, recommend: recommend, recommendsub: recommendsub)
                            self.isShowingSuccessToast = true
                        }
                    } label: {
                        Text("Done")
                            .font(.system(size: 17, weight: .heavy))
                    }
                }
            }
            .onAppear {
                genres = Array(Utils.decodeGenres(number: Int(film!.genre - 1)).prefix(3))
                title = (film?.title!)!
                review = (film?.review!)!
                recommend = film!.recommend
                recommendsub = film!.recommendsub
                filmImage = Image(uiImage: UIImage(data: (film?.poster)!)!)
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
    
    private func editFilm(review: String, recommend: Bool, recommendsub: Bool) {
        film!.review = review
        film!.recommend = recommend
        film!.recommendsub = recommendsub
        
        saveContext()
    }
}
