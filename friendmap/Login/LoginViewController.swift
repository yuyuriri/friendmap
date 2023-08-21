//
//  LoginViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/08/21.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.style = .wide
        view.backgroundColor = UIColor.DynamicBackGroundColor
        appLabel.textColor = UIColor.label
    }
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        auth()
    }

    private func auth() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        //追加
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        guard let rootViewController = window?.rootViewController else { return }
        
        
        //GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                // エラーがある場合の処理
                self.handleError(error)
                return
            }

            // ログイン成功の処理
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                // ユーザー情報が不足している場合のエラー処理
                let customError = NSError(domain: "MyApp", code: 1001, userInfo: [NSLocalizedDescriptionKey: "ユーザー情報が不足しています。"])
                self.handleError(customError)
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    // サインインに失敗した場合のエラー処理
                    self.handleError(error)
                } else {
                    // サインインに成功した場合の処理
                    
                    //追加
                    let db = Firestore.firestore()
                            let userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                            userRef.getDocument { (snapshot, error) in
                                print(snapshot)
                                if let error = error {
                                    print(error)
                                    return
                                }
                                print("exsistCheck")
                                    //取得ユーザーが存在すればHomeViewに移動
                                if snapshot?.exists == true {
                                    
            //                        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeView") as UIViewController
            //                        mainVC.modalPresentationStyle = .fullScreen
            //                        mainVC.modalTransitionStyle = .crossDissolve
            //                        self.present(mainVC, animated: true)
                                    
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as UIViewController
                                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                                    sceneDelegate.window!.rootViewController = vc
                                    
                                } else {
                                    print("notExsistAccount")
                                    // ユーザーが未登録の場合はSignUp画面に遷移
                                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                                }
                            }
                    //ここまで
                    
                    print("ログイン")
                    //self.performSegue(withIdentifier: "loginSucceed", sender: nil)
                    /*
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as UIViewController
                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.window!.rootViewController = vc
                     */
                }
            }
        }
        
    }
    
    func handleError(_ error: Error) {
        // エラー処理の具体的な実装
        print("Error: \(error.localizedDescription)")
        
    }

}
