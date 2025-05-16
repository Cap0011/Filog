//
//  SearchBar.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI

struct MySearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 38)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 2, y: 2)
                
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray7A)
                    
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text(placeholder)
                                .lineLimit(1)
                                .foregroundStyle(.graya7)
                                .font(.regular16)
                        }
                        
                        TextField("", text: $text)
                            .frame(maxWidth: .infinity)
                            .frame(height: 24)
                            .foregroundStyle(.primaryBlack)
                            .font(.regular16)
                            .submitLabel(.done)
                            .focused($isFocused)
                    }
                    
                    if isFocused {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.graya7)
                            .padding(.leading, 12)
                            .onTapGesture {
                                text = ""
                            }
                    }
                }
                .padding(.horizontal, 12)
            }
            
            if isFocused {
                Text("Cancel")
                    .foregroundStyle(.primaryBlack)
                    .font(.regular16)
                    .onTapGesture {
                        withAnimation {
                            isFocused = false
                        }
                    }
            }
        }
        .task {
            withAnimation {
                isFocused = true
            }
        }
    }
}
