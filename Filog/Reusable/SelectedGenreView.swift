//
//  SelectedGenreView.swift
//  Filog
//
//  Created by Jiyoung Park on 2022/09/07.
//

import SwiftUI

struct SelectedGenreView: View {
    let idx: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 32)
                .foregroundColor(Color("Red"))
            Text(Genres.allCases[idx].rawValue)
                .padding(.horizontal, 8)
                .foregroundColor(.white)
        }
        .frame(minWidth: 78)
        .font(.system(size: 14, weight: .black))
    }
}

struct SelectedGenreView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedGenreView(idx: 3)
    }
}
