//
//  Utils.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

class Utils {
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    static let placeholderColor: Color = Color.gray.opacity(0.1)
    
    static func decodeGenres(number: Int) -> [Int] {
        var array = [Int]()
        let binaryString = String(number, radix: 2).reversed()
        
        for (index, char) in binaryString.enumerated() {
            if char == "1" {
                array.append(index)
            }
        }
        return array
    }
    
    static func genresToInt(genres: [Int]) -> Int {
        var result = 1
        if genres.count > 0 {
            genres.prefix(3).forEach { genre in
                result += Int(pow(2.0, Double(Constants.shared.genreDictionary[genre] ?? 0)))
            }
        }
        return result
    }
    
    static func convertedGenresToInt(genres: [Int]) -> Int {
        var result = 1
        if genres.count > 0 {
            genres.prefix(3).forEach { genre in
                result += Int(pow(2.0, Double(genre)))
            }
        }
        return result
    }
    
    static func resetToRootView() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        window.rootViewController = UIHostingController(rootView: WatchedView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext))
        window.makeKeyAndVisible()
    }
}
