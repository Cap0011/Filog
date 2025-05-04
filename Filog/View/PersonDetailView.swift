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
    
    @StateObject private var personViewModel = DetailViewModel<Person>()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let person = personViewModel.detail {
                    personProfile
                    
                    if let casts = person.combinedCredits?.cast, casts.count > 0 {
                        Text("Cast")
                            .font(.semibold17)
                            .foregroundStyle(.primaryBlue)
                            .frame(height: 24)
                            .padding(.top, 28)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(casts.sorted(by: { Int($0.yearText) ?? 0 > Int($1.yearText) ?? 0 })) { cast in
                                    if let mediaType = cast.mediaType {
                                        if mediaType == "movie" {
                                            NavigationLink(destination: FilmDetailView(filmId: cast.id)) {
                                                CastCard(cast: cast)
                                            }
                                        } else if mediaType == "tv" {
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    if let crews = person.combinedCredits?.crew, crews.count > 0 {
                        Text("Crew")
                            .font(.semibold17)
                            .foregroundStyle(.primaryBlue)
                            .frame(height: 24)
                            .padding(.top, 28)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(crews.sorted { Int($0.yearText) ?? 0 > Int($1.yearText) ?? 0 }, id: \.self) { crew in
                                    if let mediaType = crew.mediaType {
                                        if mediaType == "movie" {
                                            NavigationLink(destination: FilmDetailView(filmId: crew.id)) {
                                                CrewCard(crew: crew)
                                            }
                                        } else if mediaType == "tv" {
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            personViewModel.id = self.id
        }
    }
    
    var personProfile: some View {
        Group {
            if let person = personViewModel.detail {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 12) {
                        CachedAsyncImage(url: person.profileURL, transaction: Transaction(animation: .easeInOut)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                            default: Utils.placeholderColor
                            }
                        }
                        .cornerRadius(8)
                        .aspectRatio(2/3, contentMode: .fit)
                        .frame(width: 104)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(person.name)
                                .font(.semibold20)
                                .foregroundStyle(.primaryBlack)
                                .frame(height: 24)
                                .padding(.top, 4)
                            
                            Text(person.knownForDepartment ?? "")
                                .font(.regular18)
                                .foregroundStyle(.gray3C)
                                .frame(height: 24)
                                .padding(.top, 4)
                            
                            Spacer()
                            
                            if let social = person.externalIds, let url = social.instagramURL {
                                Link(destination: url) {
                                    Image("instagram")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding(4)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Group {
                        Text("Place of birth")
                            .font(.semibold17)
                            .foregroundStyle(.primaryBlue)
                            .frame(height: 24)
                            .padding(.top, 28)
                        
                        Text(person.placeOfBirth ?? "N/A")
                            .font(.regular16)
                            .foregroundStyle(.primaryBlack)
                            .frame(height: 22)
                            .padding(.top, 8)
                        
                        Text("Birthdate")
                            .font(.semibold17)
                            .foregroundStyle(.primaryBlue)
                            .frame(height: 24)
                            .padding(.top, 24)
                        
                        Text(birthdateText(birthday: person.birthday, deathday: person.deathday))
                            .font(.regular16)
                            .foregroundStyle(.primaryBlack)
                            .frame(height: 22)
                            .padding(.top, 8)
                        
                        if let biography = person.biography {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Biography")
                                    .font(.semibold17)
                                    .foregroundStyle(.primaryBlue)
                                    .frame(height: 24)
                                    .padding(.top, 24)
                                
                                Text(biography)
                                    .font(.regular16)
                                    .foregroundStyle(.primaryBlack)
                                    .padding(.top, 8)
                                    .lineSpacing(8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            } else {
                EmptyView()
            }
        }
    }
    
    struct CastCard: View {
        let cast: CombinedCredits.Cast
        
        var body: some View {
            VStack(alignment:.leading, spacing: 0) {
                ProfileImage(imageURL: cast.posterURL)
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 104, height: 104)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cast.title ?? "N/A")
                            .font(.regular14)
                            .foregroundStyle(.primaryBlack)
                            .frame(width: 96, alignment: .leading)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 8)
                        
                        Text(cast.character ?? "N/A")
                            .font(.regular12)
                            .foregroundStyle(.gray7A)
                            .frame(width: 96, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Text(cast.yearText)
                            .font(.regular12)
                            .foregroundStyle(.gray7A)
                            .frame(height: 16)
                            .padding(.bottom, 8)
                    }
                    .frame(height: 104)
                    .padding(.horizontal, 4)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
        }
    }
    
    struct CrewCard: View {
        let crew: CombinedCredits.Crew
        
        var body: some View {
            VStack(alignment:.leading, spacing: 0) {
                ProfileImage(imageURL: crew.posterURL)
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(crew.title ?? "N/A")
                            .font(.regular14)
                            .foregroundStyle(.primaryBlack)
                            .frame(width: 96, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                        
                        Text(crew.department ?? "N/A")
                            .font(.regular12)
                            .foregroundStyle(.gray7A)
                            .frame(width: 96, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Text(crew.yearText)
                            .font(.regular12)
                            .foregroundStyle(.gray7A)
                            .frame(height: 16)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
        }
    }
    
    func birthdateText(birthday: String?, deathday: String?) -> String {
        guard let birthday = birthday else {
            return "N/A"
        }
        
        let birthDate = Utils.dateFormatter.date(from: birthday)
        let endDate = deathday.flatMap { Utils.dateFormatter.date(from: $0) } ?? Date()
        let age = Calendar.current.dateComponents([.year], from: birthDate!, to: endDate).year
        
        guard let deathday = deathday else {
            return "\(birthday) (\(age ?? 0) years old)"
        }
        return "\(birthday) ~ \(deathday) (\(age ?? 0) years old)"
    }
}

#Preview {
    PersonDetailView(id: 1138699)
}
