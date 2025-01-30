//
//  Color + Extension.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 0.7)
        return color
    }
}


extension Color {
    static func randomColor() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}
