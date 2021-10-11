//
//  ViewController.swift
//  12
//
//  Created by Евгений Таракин on 15.03.2021.
//

import UIKit


struct DataProfile {
    var login: String
    var password: String
    var dateRegistration: String
    var colorProfile: UIColor
}


class LoginViewController: UIViewController {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var authorizationLabel: UILabel?
    @IBOutlet weak var instructionLabel: UILabel?
    
    @IBOutlet weak var interConstraint: NSLayoutConstraint?

    @IBOutlet weak var labelError: UILabel?
    
    @IBOutlet weak var loginTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var entryButton: UIButton?
    @IBOutlet weak var registrationButton: UIButton?
        
    var allTextFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("727272")
        
        let tapViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(tapViewGestureRecognizer)
        
        authorizationLabel?.textColor = .white
        authorizationLabel?.font = AppFont.regular.size(36)
        
        instructionLabel?.textColor = .white
        instructionLabel?.font = AppFont.regular.size(24)

        labelError?.textColor = .red
        labelError?.alpha = 0
        
        guard let loginTextField = loginTextField,
              let passwordTextField = passwordTextField else { return }
        allTextFields.append(loginTextField)
        allTextFields.append(passwordTextField)
        editTextField(loginTextField)
        editTextField(passwordTextField)
        
        
        editButton(entryButton)
        editButton(registrationButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if view.frame.size.height < 700 {
            topConstraint?.constant = 80
            interConstraint?.constant = 40
        }
        
        guard let loginTextField = loginTextField,
              let passwordTextField = passwordTextField else { return }
        loginTextField.text = nil
        passwordTextField.text = nil
    }
    
    func editTextField(_ textField: UITextField?) {
        textField?.backgroundColor = UIColor("C4C4C4")
        textField?.font = AppFont.regular.size(24)
        textField?.layer.cornerRadius = 10.0
        textField?.layer.borderWidth = 2.0
        textField?.layer.borderColor = UIColor("565656").cgColor
        textField?.layer.masksToBounds = true
        textField?.delegate = self

        if textField == loginTextField {
            textField?.attributedPlaceholder = NSAttributedString(string: "Введите логин", attributes: [.foregroundColor: UIColor("A2A2A2")])
            textField?.returnKeyType = .next
            textField?.keyboardType = .emailAddress
        } else {
            textField?.attributedPlaceholder = NSAttributedString(string: "Введите пароль", attributes: [.foregroundColor: UIColor("A2A2A2")])
            textField?.returnKeyType = .done
            textField?.keyboardType = .default
        }
    }
    
    func editButton(_ button: UIButton?) {
        button?.backgroundColor = UIColor("3168F4")
        button?.titleLabel?.font = AppFont.regular.size(24)
        if button == entryButton {
            button?.setTitle("Войти", for: .normal)
        } else {
            button?.setTitle("Зарегистрироваться", for: .normal)
        }
    }
    
    @IBAction func tappedEntryButton(_ sender: Any) {
        if loginTextField?.text?.count == 0 || passwordTextField?.text?.count == 0 {
            labelError?.alpha = 1
            shakeTextField(allTextFields)
            UIView.animate(withDuration: 1.5) {
                self.labelError?.text = "Enter all text fields!"
                self.labelError?.alpha = 0
            }
        } else if loginTextField?.text == user?.login || passwordTextField?.text == user?.password {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "TabBarController")
            navigationController?.pushViewController(controller, animated: true)
        } else {
            labelError?.alpha = 1
            shakeTextField(allTextFields)
            UIView.animate(withDuration: 1.5) {
                self.labelError?.text = "This user doesn't exist!"
                self.labelError?.alpha = 0
            }
        }
    }
    
    @IBAction func tappedRegistrationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "RegistrationViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField?.becomeFirstResponder()
        } else if textField == passwordTextField {
            view.endEditing(true)
        }
        return false
    }
    
}
