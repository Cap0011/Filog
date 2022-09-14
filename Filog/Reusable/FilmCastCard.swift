//
//  FilmCastCard.swift
//  Filog
//
//  Created by Jiyoung Park on 2022/09/12.
//

import SwiftUI
import CachedAsyncImage

struct FilmCastCard: View {
    let name: String
    let character: String?
    let profileURL: URL
    
    var body: some View {
        VStack(spacing: 0) {
            CachedAsyncImage(url: profileURL, transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                    default: Utils.placeholderColor
                }
            }
            .aspectRatio(2/3, contentMode: .fill)
            .frame(width: 120)
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(Color("Blue"))
                Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.9)
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 8)
                    if character != nil {
                        Text(character!)
                            .lineLimit(3)
                            .font(.system(size: 12, weight: .light))
                            .padding(.horizontal, 2)
                            .padding(.top, 1)
                    }
                }
                .padding(.horizontal, 8)
                .lineSpacing(2)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            }
            .frame(width: 120, height: (character != nil) ? 90 : 70)
            .offset(y: -32)
            .padding(.bottom, -32)
        }
        .cornerRadius(4)
        .shadow(radius: 4)
    }
}
