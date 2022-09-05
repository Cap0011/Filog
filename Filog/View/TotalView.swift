//
//  TotalView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct TotalView: View {
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color("Blue"))
        UITextView.appearance().backgroundColor = .clear
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: FontManager.rubikGlitch, size: 12)! ], for: .normal)
    }
    
    var body: some View {
        TabView {
            FilmListView()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Explore")
                }
            MainView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Watched")
                }
            WatchListView()
                .tabItem {
                    Image(systemName: "list.and.film")
                    Text("To Watch")
                }
            RecommendationView()
                .tabItem {
                    Image(systemName: "rays")
                    Text("For You")
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView()
    }
}
