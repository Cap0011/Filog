//
//  RecommendationView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/27.
//

import CoreML
import SwiftUI

struct RecommendationView: View {
    @ObservedObject var recommendations = Recommender()
    
    @ObservedObject private var recommendationsState = FilmListState()
    
    @State private var isLoaded = false
    @State private var angle = 0.0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack(spacing: 16) {
                    ZStack {
                        Text("Films you might love")
                            .foregroundColor(Color("Red"))
                            .offset(x: 3)
                        
                        Text("Films you might love")
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(angle))
                                .font(.system(size: 24, weight: .semibold))
                                .onTapGesture {
                                    withAnimation {
                                        angle = 360.0
                                    }
                                    Task {
                                        recommendations.load()
                                        await recommendationsState.loadFilms(with: recommendations.filmIDs)
                                        angle = 0.0
                                    }
                                }
                        }
                    }
                    .font(.system(size: 24, weight: .black))
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
                    
                    if recommendationsState.films != nil && recommendationsState.films!.count > 0 {
                        Spacer()
                        
                        RecommendationPostersView(films: recommendationsState.films!)
                            .onAppear {
                                isLoaded = true
                            }
                    } else {
                        if recommendations.filmIDs.isEmpty {
                            Text("Leave more reviews to get personalised film recommendations!")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                        } else {
                            LoadingView(isLoading: recommendationsState.isLoading, error: recommendationsState.error) {
                                Task {
                                    await recommendationsState.loadFilms(with: recommendations.filmIDs)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if !isLoaded {
                Task {
                    recommendations.load()
                    await recommendationsState.loadFilms(with: recommendations.filmIDs)
                }
            }
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView()
    }
}
