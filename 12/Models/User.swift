//
//  User.swift
//  12
//
//  Created by Евгений Таракин on 11.10.2021.
//

import UIKit


class User {
    let login: String?
    let password: String?
    var image: UIImage?
    var color: UIColor?
    
    init(login: String?, password: String?, image: UIImage?, color: UIColor?) {
        self.login = login
        self.password = password
        self.image = image
        self.color = color
    }
}


var user: User?
