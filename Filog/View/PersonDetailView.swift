//
//  PersonDetailView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/31.
//

import SwiftUI
import CachedAsyncImage

struct PersonDetailView: View {
    let id: Int
    @State var readMoreTapped = false
    
    @ObservedObject private var personDetailState = PersonDetailState()
    
    @State var sortedCast: [Cast]?
    @State var sortedCrew: [Crew]?
    
    var body: some View {
        ZStack {
            Color("Blue").ignoresSafeArea()
            ScrollView {
                LoadingView(isLoading: self.personDetailState.isLoading, error: self.personDetailState.error) {
                    Task {
                        await self.personDetailState.loadPerson(id: self.id)
                    }
                }
                
                if personDetailState.person != nil {
                    // PersonProfileView
                    PersonProfileView(profileURL: personDetailState.person!.profileURL, name: personDetailState.person!.name, birthplace: personDetailState.person!.placeOfBirth, birthday: personDetailState.person!.birthday, deathday: personDetailState.person!.deathday, socials: personDetailState.person!.externalIds)
                    
                    // biography
                    LazyVStack(alignment: .trailing, spacing: 4) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Biography")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("Red"))
                            
                            Text(personDetailState.person!.biography)
                                .font(.system(size: 16, weight: .regular))
                                .frame(maxHeight: readMoreTapped ? .infinity : 150)
                                .lineSpacing(5)
                        }
                        
                        if !readMoreTapped {
                            HStack(spacing: 0) {
                                Text("Read More")
                                Image(systemName: "chevron.forward")
                            }
                            .foregroundColor(Color("Red"))
                            .onTapGesture {
                                readMoreTapped = true
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    
                    // Cast
                    if personDetailState.person!.cast != nil {
                        VStack(alignment: .leading) {
                            Text("Cast")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("Red"))
                                .padding(.bottom, 8)
                                .padding(.leading, 16)
                            ScrollView(.horizontal, showsIndicators: false) {
                                if sortedCast != nil {
                                    LazyHStack(spacing: 16) {
                                        ForEach(sortedCast!) { cast in
                                            NavigationLink(destination: FilmDetailView(filmId: cast.id)) {
                                                FilmCastCard(name: "\(cast.title) (\(cast.yearText))", character: cast.character, profileURL: cast.posterURL)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 245)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .onAppear {
                            sortedCast = personDetailState.person?.cast!.sorted(by: { $0.yearText > $1.yearText })
                        }
                    }
                    
                    // Crew
                    if personDetailState.person!.crew != nil {
                        VStack(alignment: .leading) {
                            Text("Crew")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("Red"))
                                .padding(.bottom, 8)
                                .padding(.leading, 16)
                            ScrollView(.horizontal, showsIndicators: false) {
                                if sortedCrew != nil {
                                    LazyHStack(spacing: 16) {
                                        ForEach(personDetailState.person!.crew!) { crew in
                                            NavigationLink(destination: FilmDetailView(filmId: crew.id)) {
                                                FilmCastCard(name: "\(crew.title) (\(crew.yearText))", character: crew.department, profileURL: crew.posterURL)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 245)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .onAppear {
                            sortedCrew = personDetailState.person?.crew!.sorted(by: { $0.yearText > $1.yearText })
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await self.personDetailState.loadPerson(id: self.id)
            }
        }
    }
}

struct PersonProfileView: View {
    let profileURL: URL
    let name: String
    let birthplace: String?
    let birthday: String?
    let deathday: String?
    let socials: Social?
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: profileURL, transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                    default: Color.gray
                }
            }
            .cornerRadius(8)
            .aspectRatio(2/3, contentMode: .fit)
            .frame(width: 150)
            
            Text(name)
                .font(.system(size: 20, weight: .black))
                .padding(.top, 8)
            
            if birthplace != nil {
                Text(birthplace!)
                    .font(.system(size: 16, weight: .thin))
                    .padding(.top, 1)
            }
            
            if birthday != nil {
                Text("\(birthday!) ~ \(deathday ?? "")")
                    .font(.system(size: 14, weight: .ultraLight))
            }
            
            if socials != nil {
                HStack(spacing: 24) {
                    if socials!.instagramURL != nil {
                        Link(destination: socials!.instagramURL!) {
                            Image("instagram")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    if socials!.facebookURL != nil {
                        Link(destination: socials!.facebookURL!) {
                            Image("facebook")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    if socials!.twitterURL != nil {
                        Link(destination: socials!.twitterURL!) {
                            Image("twitter")
                                .resizable()
                                .frame(width: 32, height: 25)
                                .tint(.white)
                        }
                    }
                }
            }
        }
    }
}
