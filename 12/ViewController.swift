//
//  ViewController.swift
//  12
//
//  Created by Евгений Таракин on 15.03.2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var authorizationLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var entryButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    
    private lazy var tapViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
    @objc func tapView() {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        moveObjects(1)
    }
    
    
    func moveObjects(_ alpha: CGFloat) {
        authorizationLabel.alpha = alpha
        instructionLabel.alpha = alpha
        entryButton.alpha = alpha
        registrationButton.alpha = alpha
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveObjects(0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            moveObjects(1)
        }
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.returnKeyType = .next
        loginTextField.keyboardType = UIKeyboardType.emailAddress
        
        passwordTextField.returnKeyType = .done
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addGestureRecognizer(tapViewGestureRecognizer)
    }


}


