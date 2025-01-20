//
//  String + Extension.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
extension String {
    
    func removingHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        return attributedString?.string ?? self
    }
    
}
