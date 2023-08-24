//
//  CustomInfoWindow.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/08/22.
//


import UIKit
import Foundation


class CustomInfoWindow: UIView {
    
//    @IBOutlet var customWindowLabel: UILabel!
//    var contentTextView: UIContentView!
    
    
    var view : UIView!
    
    
    @IBOutlet var contentTextView: UITextView!
    
    var savehitokoto: UserDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
            super.awakeFromNib()
        contentTextView.text = savehitokoto.object(forKey: "content") as? String
            
        
        }



    
    override init(frame: CGRect) {
     super.init(frame: frame)
    }

   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }



    func loadView() -> CustomInfoWindow{
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        return customInfoWindow
    }
    
    @IBAction func savehitokoto(_ sender: Any) {
        savehitokoto.set(contentTextView.text, forKey: "content")
    }

}
