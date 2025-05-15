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
    
    @State private var calendarSize = 0.0
    @State private var itemWidth = 0.0
    @State private var month = Date().get(.month)
    @State private var year = Date().get(.year)
    @State private var days = [Int]()
    
    var body: some View {
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
            .padding(.horizontal, 24)
            .padding(.top, 4)
        }
        .colorScheme(.light)
        .padding(.top, 20)
        .padding(.bottom, 26)
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.primaryBlue.opacity(0.05)).frame(width: calendarSize))
        .task {
            updateDays()
        }
        .onChange(of: month) { _ in
            updateDays()
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
}
