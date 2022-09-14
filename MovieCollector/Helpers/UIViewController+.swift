//
//  UIViewController+.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/13/22.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.tapDismissKeyboard))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapDismissKeyboard() {
        view.endEditing(true)
    }
}
