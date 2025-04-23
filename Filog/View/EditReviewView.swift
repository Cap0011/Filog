//
//  EditReviewView.swift
//  Filog
//
//  Created by Jiyoung Park on 3/27/25.
//

//import SwiftUI
//import CachedAsyncImage
//
//struct EditReviewView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @StateObject private var toastManager = ToastManager.shared
//    @FocusState private var isFocused: Bool
//    let ratingTitles = ["Not Really", "Probably", "For Sure"]
//    
//    let film: FilmData
//    
//    @State private var filmImage: Image?
//
//    @State private var selectedDate = Date()
//    @State private var reviewText = ""
//    @State private var selectedRating = 1
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            filmCard
//                .padding(.top, 24)
//                .padding(.horizontal, 16)
//                .onTapGesture {
//                    if !isFocused {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            
//            ScrollView {
//                VStack(alignment: .leading, spacing: 0) {
//                    dateSection
//                        .padding(.top, 44)
//                        .padding(.horizontal, 20)
//                    
//                    reviewSection
//                        .padding(.top, 36)
//                        .padding(.horizontal, 16)
//                    
//                    ratingSection
//                        .padding(.top, 36)
//                        .padding(.horizontal, 24)
//                }
//            }
//        }
//        .toast(message: ToastType.empty.message, isShowing: $toastManager.isShowingEmptyToast, duration: Toast.short)
//        .onTapGesture {
//            isFocused = false
//        }
//        .background(.white)
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Utils.backButton
//                    .onTapGesture {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
//            }
//            
//            ToolbarItem(placement: .principal) {
//                Text("Leave a Review")
//                    .foregroundStyle(.primaryBlack)
//                    .font(.semibold20)
//            }
//            
//            ToolbarItem(placement: .topBarTrailing) {
//                Text("Save")
//                    .foregroundStyle(reviewText.isEmpty ? .graya7 : .primaryBlue)
//                    .frame(height: 22)
//                    .onTapGesture {
//                        if reviewText.isEmpty {
//                            toastManager.isShowingEmptyToast.toggle()
//                        } else {
//                            // TODO: Save data, show toast message and return to WatchedView
//                            saveReview(id: String(film.id), title: film.title, review: reviewText, recommend: selectedRating > 0 ? true : false, recommendsub: selectedRating == 2 ? true : false, poster: filmImage)
//                            Utils.resetToRootView()
//                            toastManager.isShowingSaveToast.toggle()
//                        }
//                    }
//            }
//        }
//    }
//    
//    var filmCard: some View {
//        HStack(spacing: 16) {
//            CachedAsyncImage(url: film.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
//                switch phase {
//                case .success(let image):
//                    image
//                        .resizable()
//                        .onAppear {
//                            filmImage = image
//                        }
//                default: Color.grayf4
//                }
//            }
//            .aspectRatio(168/248 ,contentMode: .fit)
//            .frame(width: 80)
//            .cornerRadius(4)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(film.title)
//                    .lineLimit(4)
//                    .frame(minHeight: 22)
//                    .font(.medium18)
//                    .foregroundStyle(.primaryBlack)
//                
//                Text(film.yearText)
//                    .frame(height: 22)
//                    .font(.regular16)
//                    .foregroundStyle(.gray7A)
//            }
//            
//            Spacer()
//        }
//        .padding(.vertical, 20)
//        .padding(.horizontal, 16)
//        .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.white).shadow(color: .black.opacity(0.03), radius: 6, x: 4, y: 4))
//    }
//    
//    var dateSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("When did you watch the film?")
//                .foregroundStyle(.primaryBlack)
//                .font(.medium17)
//                .padding(.horizontal, 4)
//            
//            Text("\(selectedDate.formattedString(format: "MMMM")) \(selectedDate.get(.day))\(ordinalSuffix(for: selectedDate)), \(String(selectedDate.get(.year)))")
//                .foregroundStyle(.primaryBlack)
//                .font(.regular16)
//                .padding(.horizontal, 12)
//                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white).frame(height: 38).shadow(color: .black.opacity(0.05), radius: 3, x: 2, y: 2))
//                .frame(height: 38)
//                .overlay {
//                    DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {}
//                        .datePickerStyle(.compact)
//                        .labelsHidden()
//                        .colorMultiply(.clear)
//                }
//        }
//    }
//    
//    var reviewSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("How did you find it?")
//                .foregroundStyle(.primaryBlack)
//                .font(.medium17)
//                .padding(.horizontal, 4)
//            
//            ZStack(alignment: .topLeading) {
//                TextEditor(text: $reviewText)
//                    .scrollContentBackground(.hidden)
//                    .foregroundStyle(.primaryBlack)
//                    .lineSpacing(5)
//                    .frame(height: 72)
//                    .padding(.top, 12)
//                    .padding(.horizontal, 8)
//                    .padding(.bottom, 16)
//                    .offset(y: -8)
//                    .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white))
//                    .frame(height: 100)
//                    .shadow(color: .black.opacity(0.03), radius: 8, x: 4, y: 4)
//                    .focused($isFocused)
//                
//                if reviewText.isEmpty {
//                    Text("Write your thoughts about it")
//                        .foregroundStyle(.graya7)
//                        .padding(.top, 12)
//                        .padding(.horizontal, 16)
//                        .allowsHitTesting(false)
//                }
//            }
//            .font(.regular16)
//        }
//    }
//    
//    var ratingSection: some View {
//        VStack(spacing: 16) {
//            HStack {
//                Text("Would you watch it again?")
//                    .foregroundStyle(.primaryBlack)
//                    .font(.medium17)
//                
//                Spacer()
//            }
//            
//            HStack(spacing: 20) {
//                ForEach((0...2).reversed(), id: \.self) { index in
//                    RatingButton(title: ratingTitles[index], index: index, isSelected: selectedRating == index)
//                        .onTapGesture {
//                            selectedRating = index
//                        }
//                }
//            }
//        }
//    }
//    
//    struct RatingButton: View {
//        let title: String
//        let index: Int
//        let isSelected: Bool
//        
//        var body: some View {
//            ZStack {
//                RoundedRectangle(cornerRadius: 16)
//                    .frame(width: 100, height: 100)
//                    .foregroundStyle(.white)
//                    .shadow(color: .black.opacity(0.03), radius: 4, x: 4, y: 4)
//                
//                VStack(spacing: 2) {
//                    Image("rating\(index)\(isSelected ? "_selected" : "")")
//                    Text(title)
//                        .foregroundStyle(isSelected ? .primaryBlue : .graydb)
//                        .font(.semibold16)
//                }
//            }
//        }
//    }
//    
//    func ordinalSuffix(for date: Date) -> String {
//        let day = Calendar.current.component(.day, from: date)
//        
//        switch day % 10 {
//        case 1:
//            return day == 11 ? "th" : "st"
//        case 2:
//            return day == 12 ? "th" : "nd"
//        case 3:
//            return day == 13 ? "th" : "rd"
//        default:
//            return "th"
//        }
//    }
//    
//    private func saveReview(id: String, title: String, review: String, recommend: Bool, recommendsub: Bool, poster: Image?, selectedDate: Date? = nil) {
//        let newFilm = Film(context: viewContext)
//        newFilm.id = id
//        newFilm.title = title
//        newFilm.recommend = recommend
//        newFilm.recommendsub = recommendsub
//        newFilm.review = review
//        newFilm.poster = poster.snapshot().pngData()
//        newFilm.createdAt = Date()
//        newFilm.watchedAt = selectedDate
//        
//        do {
//            try viewContext.save()
//            print("Task saved successfully!")
//        } catch {
//            print("Failed to save task: \(error)")
//        }
//    }
//}
//
//#Preview {
//    EditReviewView(film: FilmData(id: 111111111, title: "Kill Your Darlings", backdropPath: nil, posterPath: "/wYM8VUTh0y6ugSmza1c2MJWCMfO.jpg", overview: "A murder in 1944 draws together the great poets of the beat generation: Allen Ginsberg, Jack Kerouac and William Burroughs.", voteAverage: 0, voteCount: 0, runtime: 137, releaseDate: "2013-10-16", adult: false, genreIds: [18, 10749], genres: nil, credits: nil, videos: nil))
//}
