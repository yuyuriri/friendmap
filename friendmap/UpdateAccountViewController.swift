//
//  UpdateAccountViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/08/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol CatchProtocol {
    
    func catchData(newAccountName: String)
    
}

class UpdateAccountViewController: UIViewController {
    
    //プロトコルを変数化する
    var delegate:CatchProtocol?
    
    @IBOutlet var accountField: UITextField!
    @IBOutlet var updateButton: UIButton!
    var userManager = UserManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        addStyle(to: updateButton)
        updateButton.layer.cornerRadius = 5
        AccountDisplay()
        
        
        
    }
    
    @IBAction func accountUpdateButtonTapped(_ sender: UIButton){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if let accountTitle = accountField.text, !accountTitle.isEmpty {
            //            userManager.updateAccount(displayName: accountField.text!, userID: uid)
            
            //元の画面に書いたcatchDataメソッドが呼ばれる、passedCounterの中身を受け渡す
            delegate?.catchData(newAccountName: accountTitle)
            
            //元の画面に戻る処理
            dismiss(animated: true, completion: nil)
            
            
            //            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func AccountDisplay() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        //        self.userManager.getUserDisplayName { displayName in
        //            DispatchQueue.main.async {
        //                self.accountField.text = displayName
        //            }
    }
}

//影のスタイル
func addStyle(to button: UIButton!){
    //影の濃さ
    button.layer.shadowOpacity = 0.1
    //ぼかしの大きさ
    button.layer.shadowRadius = 3
    //いろ
    button.layer.shadowColor = UIColor.black.cgColor
    //影の方向
    button.layer.shadowOffset = CGSize(width: 2, height: 2)
}

//他の場所タップするとキーボードが閉じる
//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    self.view.endEditing(true)
//}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

