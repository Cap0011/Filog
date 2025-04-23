//
//  FilmSearchRow.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI
import CachedAsyncImage

struct FilmSearchRow: View {
    let film: FilmData
    var query: String? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                CachedAsyncImage(url: film.posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        default: Utils.placeholderColor
                    }
                }
                .aspectRatio(168/248 ,contentMode: .fill)
                .frame(width: 50)
                .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(highlightedString(from: film.title ?? "N/A", query: query ?? ""))
                        .lineLimit(1)
                        .frame(height: 22)
                    
                    Text(film.yearText)
                        .font(.regular14)
                        .foregroundStyle(.gray7A)
                        .frame(height: 20)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.grayf4)
                .padding(.horizontal, -5)
        }
        .background(.white)
    }
    
    func highlightedString(from text: String, query: String) -> AttributedString {
        let words = text.split(separator: " ").map { String($0) }
        var attributedString = AttributedString("")
        
        let queryWords = query.split(separator: " ").map { String($0) }
        
        for word in words {
            var string = AttributedString(word)
            string.foregroundColor = .gray3C
            string.font = .medium16
            
            for queryWord in queryWords {
                if let range = string.range(of: queryWord, options: .caseInsensitive) {
                    string[range].foregroundColor = Color.gray7A
                    string[range].font = .regular16
                }
            }
            attributedString.append(string)
            attributedString.append(AttributedString(" "))
        }
        
        return attributedString
    }
}

