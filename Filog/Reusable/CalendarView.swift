//
//  CalendarView.swift
//  Filog
//
//  Created by Jiyoung Park on 5/7/25.
//

import SwiftUI

struct CalendarView: View {
    let reviews: [Film]
    
    let calendar = Calendar.current
    let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    @State private var calendarSize = 0.0
    @State private var itemWidth = 0.0
    @State private var month = Date().get(.month)
    @State private var year = Date().get(.year)
    @State private var days = [Int]()
    
    @State private var filteredReviews = [Film]()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 10))
                        .rotationEffect(.degrees(-90))
                        .foregroundStyle(.gray3C)
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            withAnimation {
                                if month == 1 {
                                    year -= 1
                                }
                                month = (month + 10) % 12 + 1
                            }
                        }
                    
                    Text("\(String(year)).\(String(format: "%02d", month))")
                        .foregroundStyle(.primaryBlack)
                        .font(.semibold24)
                    
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 10))
                        .rotationEffect(.degrees(90))
                        .foregroundStyle(.gray3C)
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            withAnimation {
                                if month == 12 {
                                    year += 1
                                }
                                month = month % 12 + 1
                            }
                        }
                }
                .padding(.bottom, 15)
                
                HStack(spacing: 2) {
                    ForEach(weekdays, id: \.self) { weekday in
                        Text(weekday)
                            .kerning(0.2)
                            .font(.regular12)
                            .foregroundStyle(.gray7A)
                            .frame(width: itemWidth)
                    }
                }
                
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(days.indices, id: \.self) { index in
                        if days[index] > 0 {
                            if let review = reviews.filter({ $0.watchedAt != nil && calendar.isDate(Date.date(year: year, month: month, day: days[index]), inSameDayAs: $0.watchedAt!) }).first, let poster = UIImage(data: review.poster ?? Data()), let id = Int(review.id ?? "") {
                                NavigationLink(destination: FilmDetailView(filmId: id)) {
                                    Image(uiImage: poster)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: itemWidth, height: itemWidth * 3 / 2)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                            } else {
                                Text("\(days[index])")
                                    .font(.regular14)
                                    .kerning(0.2)
                                    .foregroundStyle(index % 7 == 0 ? .calendarRed : index % 7 == 6 ? .calendarBlue : .gray3C)
                                    .frame(width: itemWidth, height: itemWidth * 3 / 2)
                            }
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: itemWidth, height: itemWidth * 3 / 2)
                        }
                    }
                }
                .padding(.top, 4)
                .padding(.horizontal, 24)
            }
            .padding(.top, 20)
            .padding(.bottom, 26)
            .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.primaryBlue.opacity(0.05)).frame(width: calendarSize))
            .padding(.bottom, 16)
            
            HStack(alignment: .bottom, spacing: 8) {
                Text("\(filteredReviews.count) films")
                    .font(.semibold24)
                    .foregroundStyle(.primaryBlue)
                
                Text("in \(months[month - 1]) of \(String(year))")
                    .font(.regular18)
                    .foregroundStyle(.gray7A)
                    .offset(y: -1)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            ForEach(filteredReviews, id: \.id) { review in
                NavigationLink(destination: FilmDetailView(filmId: Int(review.id ?? "0") ?? 0)) {
                    ReviewCard(review: review)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                }
            }
        }
        .padding(.bottom, 30)
        .colorScheme(.light)
        .task {
            updateDays()
            filteredReviews = reviews.filter { $0.watchedAt != nil && $0.watchedAt!.get(.month) == month }
        }
        .onChange(of: month) { _ in
            updateDays()
            filteredReviews = reviews.filter { $0.watchedAt != nil && $0.watchedAt!.get(.month) == month }
        }
        .readSize { size in
            calendarSize = (size.width - 32)
            itemWidth = (size.width - 60) / 7
        }
    }
    
    private func updateDays() {
        days = Array(repeating: 0, count: calendar.component(.weekday, from: Date.date(year: year, month: month, day: 1)) - 1) +
        Array(calendar.range(of: .day, in: .month, for: Date.date(year: year, month: month, day: 1)) ?? 1..<30)
    }
    
    struct ReviewCard: View {
        let review: Film
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                if let data = review.poster {
                    Image(uiImage: UIImage(data: data) ?? UIImage())
                        .resizable()
                        .frame(width: 104, height: 156, alignment: .center)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Utils.placeholderColor)
                        .frame(width: 104, height: 156, alignment: .center)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(review.title ?? "N/A")
                        .font(.medium17)
                        .foregroundStyle(.primaryBlack)
                        .padding(.top, 8)
                        .multilineTextAlignment(.leading)
                    
                    Text(review.review ?? "")
                        .font(.regular14)
                        .foregroundStyle(.primaryBlack)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .lineSpacing(2)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("Watched at")
                            .font(.regular14)
                            .foregroundStyle(.gray7A)
                        
                        Text(review.watchedAt?.formattedString(format: "yyyy.MM.dd") ?? "Unknown")
                            .font(.regular14)
                            .foregroundStyle(.gray3C)
                        
                        Spacer()
                        
                        Image("rating\(!review.recommend ? "0" : !review.recommendsub ? "1" : "2")_selected")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white).shadow(color: .black.opacity(0.06), radius: 8))
        }
    }
}
