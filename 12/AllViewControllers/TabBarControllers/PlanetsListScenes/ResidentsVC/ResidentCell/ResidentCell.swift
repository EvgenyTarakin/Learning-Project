//
//  ResidentCell.swift
//  12
//
//  Created by Евгений Таракин on 25.04.2021.
//

import UIKit


class ResidentCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView?
    @IBOutlet weak var avatarHuman: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var sexLabel: UILabel?
    @IBOutlet weak var speciesLabel: UILabel?
 
    var idURLString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        
        avatarHuman?.layer.cornerRadius = 15
    }
    
}
