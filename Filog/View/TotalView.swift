//
//  TotalView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct TotalView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                FilmListView()
            }
            .tabItem {
                Image(systemName: "doc.text.magnifyingglass")
                Text("Explore")
            }
            .tag(0)
            
            NavigationStack {
                WatchedView()
            }
            .tabItem {
                Image(systemName: "film")
                Text("Watched")
            }
            .tag(1)
            
            NavigationStack {
                WatchListView()
            }
            .tabItem {
                Image(systemName: "list.and.film")
                Text("To Watch")
            }
            .tag(2)
        }
        .preferredColorScheme(.light)
    }
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView()
    }
}
