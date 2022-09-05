//
//  MainCardView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct MainCardView: View {
    
    @ObservedObject var film: Film
    
    var body: some View {
        if film.poster != nil {
            VStack(spacing: 0) {
                let img = Image(uiImage: UIImage(data: film.poster!)!)
                img
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(width: (UIScreen.main.bounds.size.width - 48) / 2)
                    .scaledToFit()
                
                MainTextView(title: film.title!, review: film.review!, recommend: film.recommend)
            }
            .background(.black)
            .padding(.top, -12)
            .cornerRadius(8)
        }
    }
}

struct MainTextView: View {
    var title: String
    var review: String
    var recommend: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 18)
                .frame(width: 36, height: 36)
                .foregroundColor(Color("LightBlue"))
                .offset(y: -18)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .black))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.size.width / 2 - 24 - 8)
                Text(review)
                    .font(.system(size: 14, weight: .light))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.size.width / 2 - 24 - 8)
            }
            .foregroundColor(.black)
            .padding(.bottom, 16)
            .padding(.top, 12)
            .padding(.horizontal, 8)
            
            if recommend {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color("Red"))
                    .font(.system(size: 20))
                    .offset(y: -12)
            } else {
                Image(systemName: "heart.slash")
                    .foregroundColor(Color("Red"))
                    .font(.system(size: 20))
                    .offset(y: -12)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width / 2 - 24)
        .background(Color("LightBlue"))
    }
}
