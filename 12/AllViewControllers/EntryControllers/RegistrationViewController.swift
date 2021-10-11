//
//  RegistrationViewController.swift
//  12
//
//  Created by Евгений Таракин on 22.03.2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var labelError: UILabel?
    
    @IBOutlet var collectionRegistrationTextFieldsOutlets: [UITextField]!

    @IBOutlet weak var registrationScrollView: UIScrollView?
    @IBOutlet weak var registrationButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor("727272")
        
        let tapViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(tapViewGestureRecognizer)
        
        labelError?.text = "Enter all text fields!"
        labelError?.textColor = .red
        labelError?.alpha = 0
        
        registerForKeyboardNotifications()
        
        for textField in collectionRegistrationTextFieldsOutlets {
            editTextField(textField)
        }
        
        editButton(registrationButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if view.frame.size.height < 700 {
            topConstraint?.constant = 80
        }
    }
    
    func editTextField(_ textField: UITextField?) {
        textField?.backgroundColor = UIColor("C4C4C4")
        textField?.font = AppFont.regular.size(24)
        textField?.layer.cornerRadius = 10.0
        textField?.layer.borderWidth = 2.0
        textField?.layer.borderColor = UIColor("565656").cgColor
        textField?.layer.masksToBounds = true
        textField?.delegate = self
        switch textField {
        case collectionRegistrationTextFieldsOutlets[0]:
            textField?.attributedPlaceholder = NSAttributedString(string: "Введите логин", attributes: [.foregroundColor: UIColor("A2A2A2")])
            textField?.returnKeyType = .next
            textField?.keyboardType = .emailAddress
        case collectionRegistrationTextFieldsOutlets[1]:
            textField?.attributedPlaceholder = NSAttributedString(string: "Введите пароль", attributes: [.foregroundColor: UIColor("A2A2A2")])
            textField?.returnKeyType = .next
            textField?.keyboardType = .default
        default:
            textField?.attributedPlaceholder = NSAttributedString(string: "Повторите пароль", attributes: [.foregroundColor: UIColor("A2A2A2")])
            textField?.returnKeyType = .done
            textField?.keyboardType = .default
        }
    }
    
    func editButton(_ button: UIButton?) {
        button?.backgroundColor = UIColor("3168F4")
        button?.titleLabel?.font = AppFont.regular.size(24)
        button?.setTitle("Готово", for: .normal)
    }
    
    @IBAction func tappedReadyButton(_ sender: Any) {
        if collectionRegistrationTextFieldsOutlets[0].text?.count == 0 ||
            collectionRegistrationTextFieldsOutlets[1].text?.count == 0 ||
            collectionRegistrationTextFieldsOutlets[2].text?.count == 0 {
            labelError?.alpha = 1
            shakeTextField(collectionRegistrationTextFieldsOutlets)
            UIView.animate(withDuration: 1.5) {
                self.labelError?.alpha = 0
            }
        } else {
            user = User(login: collectionRegistrationTextFieldsOutlets[0].text, password: collectionRegistrationTextFieldsOutlets[1].text, image: nil, color: .systemPurple)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let keyBoardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var insets = registrationScrollView?.contentInset
            insets?.bottom = keyBoardSize.height
            guard let insets = insets else { return }
            registrationScrollView?.contentInset = insets
        }
    }
   
    @objc func keyboardWillHide() {
        registrationScrollView?.contentInset = .zero
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            return false
        }
        
        let sortedCollectionTextFields = collectionRegistrationTextFieldsOutlets.sorted {
            $0.frame.origin.y < $1.frame.origin.y
        }

        guard textField.returnKeyType == .next,
              let index = sortedCollectionTextFields.firstIndex(of: textField),
              sortedCollectionTextFields.count > index + 1
        else { return false }
        
        let nextTextField = sortedCollectionTextFields[index + 1]
        nextTextField.becomeFirstResponder()
        
        return false
    }
    
}
