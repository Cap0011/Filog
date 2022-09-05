//
//  FilmDetailSheetView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/09/04.
//

import SwiftUI

struct FilmDetailSheetView: View {
    let filmId: Int
    
    @Binding var isShowingSheet: Bool

    var body: some View {
        VStack {
            FilmDetailView(filmId: filmId)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isShowingSheet.toggle()
                } label: {
                    Text("Cancel")
                }
            }
        }
    }
}
