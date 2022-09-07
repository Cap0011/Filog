//
//  GenreView.swift
//  Filog
//
//  Created by Jiyoung Park on 2022/09/07.
//

import SwiftUI

struct GenreView: View {
    let idx: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("LightRed"), lineWidth: 1)
                .frame(height: 30)
            Text(Genres.allCases[idx].rawValue)
                .padding(.horizontal, 8)
                .foregroundColor(Color("LightRed"))
        }
        .frame(minWidth: 76)
        .font(.system(size: 14, weight: .black))
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView(idx: 15)
    }
}
