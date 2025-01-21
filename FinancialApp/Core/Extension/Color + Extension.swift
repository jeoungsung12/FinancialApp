//
//  Color + Extension.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import Foundation
import UIKit

extension UIColor {
    static let keyColor : UIColor = {
        return UIColor(named: "KeyColor") ?? .white
    }()
    static let graph_1 : UIColor = {
        return UIColor(named: "graph1") ?? .white
    }()
    static let graph_2 : UIColor = {
        return UIColor(named: "graph2") ?? .white
    }()
    static let graph_3 : UIColor = {
        return UIColor(named: "graph3") ?? .white
    }()
    static let TabColor : UIColor = {
        return UIColor(named: "TabColor") ?? .white
    }()
    static let BackColor : UIColor = {
        return UIColor(named: "BackColor") ?? .white
    }()
    static let BackColor2 : UIColor = {
        return UIColor(named: "BackColor2") ?? .white
    }()
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 0.7)
        return color
    }
}
