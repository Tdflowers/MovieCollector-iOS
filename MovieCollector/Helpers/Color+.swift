//
//  UIColor+.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import Foundation
import UIKit

extension UIColor {
    static var myControlWhiteBlackBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                // Return one of two colors depending on light or dark mode
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 1, green: 1, blue: 1, alpha: 1) : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
        } else {
            // Same old color used for iOS 12 and earlier
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
