//
//  EditReviewView.swift
//  Filog
//
//  Created by Jiyoung Park on 5/6/25.
//

import SwiftUI
import CachedAsyncImage

struct EditReviewView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject private var toastManager = ToastManager.shared
    @FocusState private var isFocused: Bool
    let ratingTitles = ["Not Really", "Probably", "For Sure"]

    let film: FilmData
    let review: Film?

    @State private var selectedDate: Date? = nil
    @State private var reviewText = ""
    @State private var selectedRating = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            filmCard
                .padding(.top, 24)
                .padding(.horizontal, 16)
                .onTapGesture {
                    if !isFocused && review == nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    dateSection
                        .padding(.top, 44)
                        .padding(.horizontal, 20)

                    reviewSection
                        .padding(.top, 36)
                        .padding(.horizontal, 16)

                    ratingSection
                        .padding(.top, 36)
                        .padding(.horizontal, 24)
                }
            }
        }
        .toast(message: ToastType.empty.message, isShowing: $toastManager.isShowingEmptyToast, duration: Toast.short)
        .task {
            if let review = review {
                selectedDate = review.watchedAt
                reviewText = review.review ?? ""
                selectedRating = !review.recommend ? 0 : (!review.recommendsub ? 1 : 2)
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Utils.backButton
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }

            ToolbarItem(placement: .principal) {
                Text("Leave a Review")
                    .foregroundStyle(.primaryBlack)
                    .font(.semibold20)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Text("Save")
                    .foregroundStyle(reviewText.isEmpty ? .graya7 : .primaryBlue)
                    .frame(height: 22)
                    .onTapGesture {
                        if reviewText.isEmpty {
                            toastManager.isShowingEmptyToast.toggle()
                        } else {
                            saveReview()
                            if review != nil {
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                Utils.resetToRootView()
                            }
                            toastManager.isShowingSaveToast.toggle()
                        }
                    }
            }
        }
    }

    var filmCard: some View {
        HStack(spacing: 16) {
            CachedAsyncImage(url: film.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, alignment: .top)
                default: Utils.placeholderColor
                        .frame(width: 80, height: 120)
                }
            }
            .cornerRadius(4)

            VStack(alignment: .leading, spacing: 4) {
                Text(film.displayTitle)
                    .lineLimit(4)
                    .frame(minHeight: 22)
                    .font(.medium18)
                    .foregroundStyle(.primaryBlack)

                Text(film.yearText)
                    .frame(height: 22)
                    .font(.regular16)
                    .foregroundStyle(.gray7A)
            }

            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.white).shadow(color: .black.opacity(0.03), radius: 6, x: 4, y: 4))
    }

    var dateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("When did you watch the film?")
                .foregroundStyle(.primaryBlack)
                .font(.medium17)
                .padding(.horizontal, 4)

            Text(selectedDate != nil ? dateString(for: selectedDate!) : "Select a date")
                .foregroundStyle(selectedDate != nil ? .primaryBlack : .graya7)
                .font(.regular16)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white).frame(height: 38).shadow(color: .black.opacity(0.05), radius: 3, x: 2, y: 2))
                .frame(height: 38)
                .overlay {
                    DatePicker(selection: Binding($selectedDate, default: Date()), in: ...Date.now, displayedComponents: .date) {}
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorMultiply(.clear)
                }
        }
    }

    var reviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How did you find it?")
                .foregroundStyle(.primaryBlack)
                .font(.medium17)
                .padding(.horizontal, 4)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $reviewText)
                    .scrollContentBackground(.hidden)
                    .foregroundStyle(.primaryBlack)
                    .lineSpacing(5)
                    .frame(height: 72)
                    .padding(.top, 12)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                    .offset(y: -8)
                    .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white))
                    .frame(height: 100)
                    .shadow(color: .black.opacity(0.03), radius: 8, x: 4, y: 4)
                    .focused($isFocused)

                if reviewText.isEmpty {
                    Text("Write your thoughts about it")
                        .foregroundStyle(.graya7)
                        .padding(.top, 12)
                        .padding(.horizontal, 16)
                        .allowsHitTesting(false)
                }
            }
            .font(.regular16)
        }
    }

    var ratingSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Would you watch it again?")
                    .foregroundStyle(.primaryBlack)
                    .font(.medium17)

                Spacer()
            }

            HStack(spacing: 20) {
                ForEach((0...2).reversed(), id: \.self) { index in
                    RatingButton(title: ratingTitles[index], index: index, isSelected: selectedRating == index)
                        .onTapGesture {
                            selectedRating = index
                        }
                }
            }
        }
    }

    struct RatingButton: View {
        let title: String
        let index: Int
        let isSelected: Bool

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(isSelected ? .primaryBlue : .white)
                    .shadow(color: .black.opacity(0.03), radius: 4, x: 4, y: 4)

                VStack(spacing: 2) {
                    Image("rating\(index)")
                        .renderingMode(.template)
                        .foregroundStyle(isSelected ? .white : .graydb)
                    Text(title)
                        .foregroundStyle(isSelected ? .white : .graydb)
                        .font(.semibold16)
                }
            }
        }
    }
    
    func dateString(for date: Date) -> String {
        return "\(date.formattedString(format: "MMMM")) \(date.get(.day))\(ordinalSuffix(for: date)), \(String(date.get(.year)))"
    }

    func ordinalSuffix(for date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)

        switch day % 10 {
        case 1:
            return day == 11 ? "th" : "st"
        case 2:
            return day == 12 ? "th" : "nd"
        case 3:
            return day == 13 ? "th" : "rd"
        default:
            return "th"
        }
    }

    private func saveReview() {
        if let review = self.review {
            review.watchedAt = selectedDate
            review.review = reviewText
            review.recommend = selectedRating > 0
            review.recommendsub = selectedRating == 2
        } else {
            let newReview = Film(context: viewContext)
            newReview.id = String(film.id)
            newReview.title = film.displayTitle
            newReview.watchedAt = selectedDate
            newReview.createdAt = Date()
            newReview.review = reviewText
            newReview.recommend = selectedRating > 0
            newReview.recommendsub = selectedRating == 2
            if let posterURL = film.posterURL {
                newReview.posterURL = posterURL.absoluteString
            }
        }

        do {
            try viewContext.save()
            print("Task saved successfully!")
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}
