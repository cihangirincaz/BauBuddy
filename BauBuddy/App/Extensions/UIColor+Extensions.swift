//
//  UIColor+Extensions.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import Foundation
import UIKit

extension UIColor {
    static var placeholder = UIColor(red: 0.709, green: 0.709, blue: 0.709, alpha: 1)
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}


