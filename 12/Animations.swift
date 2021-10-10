//
//  Animations.swift
//  12
//
//  Created by Евгений Таракин on 23.04.2021.
//

import UIKit
import AudioToolbox

func shakeTextField(_ textFields: [UITextField]) {
    for textField in textFields {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.layer.position.x + 5, y: textField.layer.position.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.layer.position.x - 5, y: textField.layer.position.y))
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        textField.layer.add(animation, forKey: "position")
    }
    Vibration.error.vibrate()
}
