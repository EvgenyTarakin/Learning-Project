//
//  UserAuthorizationViewController.swift
//  12
//
//  Created by Евгений Таракин on 04.04.2021.
//

import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileBackImageView: UIImageView?
    @IBOutlet weak var profileBackColorView: UIView?
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var changeAvatarButton: UIButton?
    @IBOutlet weak var profileLoginLabel: UILabel?
    @IBOutlet weak var profileCollectionView: UICollectionView?
    
    @IBOutlet weak var interConstraint: NSLayoutConstraint?
    @IBOutlet weak var interConstraint2: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("727272")
        guard let user = user else { return }
        profileBackColorView?.backgroundColor = user.color
        profileBackColorView?.alpha = 0.5
        
        guard let width = avatarImageView?.frame.size.width else { return }
        avatarImageView?.layer.cornerRadius = width / 2
        if user.image == nil {
            avatarImageView?.image = UIImage(named: "avatar")
        } else {
            avatarImageView?.image = user.image
            profileBackImageView?.image = user.image
            avatarImageView?.layer.borderWidth = 5.0
            avatarImageView?.layer.borderColor = UIColor.white.cgColor
        }
        
        changeAvatarButton?.titleLabel?.alpha = 0
        changeAvatarButton?.addTarget(self, action: #selector(tapAvatar), for: .touchUpInside)
        
        profileLoginLabel?.font = AppFont.regular.size(36)
        profileLoginLabel?.text = user.login
        
        profileCollectionView?.backgroundColor = .clear
        profileCollectionView?.delegate = self
        profileCollectionView?.dataSource = self
        
        profileCollectionView?.register(UINib(nibName: "DataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DataCollectionViewCell")    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if view.frame.size.height < 700 {
            interConstraint?.constant = 30
            interConstraint2?.constant = 30
        }
    }
    
    @objc func tapAvatar() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func exitButton(_ sender: Any) {
        navigationController?.tabBarController?.navigationController?.popToRootViewController(animated: true)
    }
    
    
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        profileBackImageView?.image = image
        avatarImageView?.image = image
        guard let user = user else { return }

        user.image = image
        avatarImageView?.layer.borderWidth = 5.0
        avatarImageView?.layer.borderColor = UIColor.white.cgColor
        dismiss(animated: true)
    }
    
}


extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? DataCollectionViewCell
        if indexPath.item == 1 {
            UIView.animate(withDuration: 0.3) {
                guard let user = user else { return }

                switch Int.random(in: 1...5) {
                case 1:
                    self.profileBackColorView?.backgroundColor = .systemPurple
                    cell?.userColorView?.backgroundColor = .systemPurple
                    user.color = .systemPurple
                case 2:
                    self.profileBackColorView?.backgroundColor = .systemPink
                    cell?.userColorView?.backgroundColor = .systemPink
                    user.color = .systemPink
                case 3:
                    self.profileBackColorView?.backgroundColor = .systemGreen
                    cell?.userColorView?.backgroundColor = .systemGreen
                    user.color = .systemGreen
                case 4:
                    self.profileBackColorView?.backgroundColor = .systemBlue
                    cell?.userColorView?.backgroundColor = .systemBlue
                    user.color = .systemBlue
                default:
                    self.profileBackColorView?.backgroundColor = .systemYellow
                    cell?.userColorView?.backgroundColor = .systemYellow
                    user.color = .systemYellow
                }
            }
        }
    }
    
}


extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as? DataCollectionViewCell else { return UICollectionViewCell() }

        cell.labelCell?.textColor = UIColor("565656")
        cell.labelCell?.font = AppFont.regular.size(14)
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "d.LL.Y"
        cell.dateLabel?.text = dataFormatter.string(from: Date())
        cell.dateLabel?.textColor = .black
        cell.dateLabel?.font = AppFont.regular.size(14)
        
        cell.userColorView?.backgroundColor = profileBackColorView?.backgroundColor
        cell.userColorView?.alpha = 0.5

        cell.bottomView?.backgroundColor = UIColor("000000")
        cell.bottomView?.alpha = 0.64
        
        if indexPath.item == 0 {
            cell.labelCell?.text = "Дата регистрации"
            cell.dateLabel?.isHidden = false
            cell.userColorView?.isHidden = true
            cell.bottomView?.isHidden = false
        } else {
            cell.labelCell?.text = "Цвет профиля"
            cell.dateLabel?.isHidden = true
            cell.userColorView?.isHidden = false
            cell.bottomView?.isHidden = true
        }
        
        return cell
    }
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 58)
    }
    
}


