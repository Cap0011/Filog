//
//  TotalView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct TotalView: View {
    var body: some View {
        TabView {
            FilmListView()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Explore")
                }
            
            WatchedView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Watched")
                }
            
            WatchListView()
                .tabItem {
                    Image(systemName: "list.and.film")
                    Text("To Watch")
                }
        }
        .preferredColorScheme(.light)
    }
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView()
    }
}
