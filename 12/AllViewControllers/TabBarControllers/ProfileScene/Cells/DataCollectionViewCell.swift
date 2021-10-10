//
//  DataCollectionViewCell.swift
//  12
//
//  Created by Евгений Таракин on 29.09.2021.
//

import UIKit


class DataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView?
    @IBOutlet weak var labelCell: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var userColorView: UIView?
    @IBOutlet weak var bottomView: UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView?.backgroundColor = UIColor("C4C4C4")
        
        userColorView?.layer.cornerRadius = 8
    }
}
