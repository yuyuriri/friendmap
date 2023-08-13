//
//  NewroomCollectionViewCell.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/06/14.
//

import UIKit

class NewroomCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //角丸にする
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        //透明度
        self.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
    
    

}
