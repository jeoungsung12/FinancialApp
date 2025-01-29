//
//  String + Extension.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import UIKit

extension String {
    
    static func checkProfileImage(_ image: UIImage?) -> String {
        guard let image = image else { return "" }
        for imageString in ProfileData.allCases {
            if UIImage(named: imageString.rawValue) == image {
                return imageString.rawValue
            }
        }
        return ""
    }
    
    static var currentDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy.MM.dd 가입"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: Date())
        }
    }
    
    func removingHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        return attributedString?.string ?? self
    }
    
    func returnToKorea() -> String {
        
        return ""
    }
    
}
