//
//  FindView.swift
//  Filog
//
//  Created by Jiyoung Park on 3/26/25.
//

import SwiftUI

struct FindView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = FilmViewModel()

    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            MySearchBar(text: $viewModel.searchText, placeholder: "Search by film title")
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { film in
                        FilmSearchRow(film: film)
                    }
                }
                .padding(.top, 24)
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            isFocused = true
        }
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(.primaryBlack)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Find a Film")
                    .foregroundStyle(.primaryBlack)
                    .font(.semibold20)
            }
        }
    }
}

#Preview {
    FindView()
}
