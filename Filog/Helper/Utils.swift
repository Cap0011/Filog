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
    
    static var screenWidth: CGFloat = 0.0
    
    static let placeholderColor: Color = .grayf4
    
    static var backButton: some View {
        ZStack {
            Circle()
                .frame(width: 44, height: 44)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                .foregroundStyle(.white.opacity(0.6))
                .background(.ultraThickMaterial.opacity(0.3))
            
            Image(systemName: "chevron.backward")
                .foregroundStyle(.primaryBlue)
        }
        .clipShape(Circle())
    }

    static func resetToRootView() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        window.rootViewController = UIHostingController(rootView: TotalView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext))
        window.makeKeyAndVisible()
    }
}
