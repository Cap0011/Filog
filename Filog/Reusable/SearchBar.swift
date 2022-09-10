//
//  SearchBar.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI

struct SearchBar: View {
    let isFocusedFirst: Bool
    
    @FocusState private var isFocused: Bool
    
    @Binding var searchTitle: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(height: 32)
                HStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 8)
                    ZStack(alignment: .leading) {
                        if searchTitle.isEmpty  {
                            Text("Film title")
                        }
                        TextField("", text: $searchTitle) { startedEditing in
                            if startedEditing {
                                isFocused = true
                                withAnimation {
                                    isSearching = true
                                }
                            }
                        } onCommit: {
                            isFocused = false
                            withAnimation {
                                isSearching = false
                            }
                        }
                        .focused($isFocused)
                    }
                }
            }
            if isSearching {
                Button {
                    searchTitle = ""
                    isFocused = false
                    withAnimation {
                        isSearching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                } label: {
                    Text("Cancel")
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFocused = isFocusedFirst
            }
        }
        .font(.custom(FontManager.rubikGlitch, size: 16))
        .foregroundColor(isSearching ? .white : .white.opacity(0.6))
        .padding(.horizontal, 16)
    }
}
