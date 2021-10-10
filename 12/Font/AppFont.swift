//
//  AppFont.swift
//  12
//
//  Created by Евгений Таракин on 18.09.2021.
//

import UIKit

private let familyName = "Roboto"

enum AppFont: String {
    case regular = "Regular"
    case medium = "Medium"

    func size(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }
    
    fileprivate var fullFontName: String {
        return rawValue.isEmpty ? familyName : familyName + "-" + rawValue
    }
}
