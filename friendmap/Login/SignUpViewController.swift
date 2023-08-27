//
//  SignUpViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/08/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var signupView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor.DynamicBackGroundColor
        
        registerButton.layer.cornerRadius = 5
        registerButton.layer.shadowColor = UIColor.gray.cgColor
        registerButton.layer.shadowOpacity = 0.1
        registerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        registerButton.layer.shadowRadius = 3
        
        
    }
    
   
    
    @IBAction func registerButtonTapped() {
        // ユーザーが入力した名前を取得
        if let name = nameTextField.text, !name.isEmpty {
            // 入力した名前を使用して、Userオブジェクトを作成
            let user = User(displayName: name, createdTime: Date(), uid: Auth.auth().currentUser!.uid)
            
            // Firestoreのコレクションにアクセス
            let db = Firestore.firestore()
            
            // UserDataStoreクラスのcreateUser関数を呼び出し、Firestoreに新しいユーザーを追加
            UserDataStore.createUser(user: user) { (success) in
                if success {
//
//                    // ホーム画面に遷移
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TopmenuViewController") as UIViewController
                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.window!.rootViewController = vc
                } else {
                    print("Failed to create user")
                }
            }
        }
    }
    
    //影のスタイル
//    @IBAction func addStyle(to button: UIButton!){
//        //影の濃さ
//        button.layer.shadowOpacity = 0.1
//        //ぼかしの大きさ
//        button.layer.shadowRadius = 5
//        //いろ
//        button.layer.shadowColor = UIColor.black.cgColor
//        //影の方向
//        button.layer.shadowOffset = CGSize(width: 2, height: 2)
//    }
    
    //他の場所タップするとキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
