//
//  TopmenuCollectionViewCell.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/06/07.
//

import UIKit
import Accounts

class TopmenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var maintitleLabel: UILabel!
    
    @IBOutlet var maindateLabel: UILabel!
    
    @IBOutlet var mainImageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        maintitleLabel.text = ""
        mainImageView.image = UIImage()
        
    }
    
    //cellに表示されているパーツにデータを割り振る
    func setupCell(mainTitle: String, mainDate: Date, mainImageData: Data) {
        dateFormatter.dateFormat = "YY/MM/dd HH:mm"
        
        maintitleLabel.text = mainTitle
        maindateLabel.text = dateFormatter.string(from: mainDate)
        mainImageView.image = UIImage(data: mainImageData)
        
        //角丸にする
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
            CGAffineTransform.identity
        })
    }
}
