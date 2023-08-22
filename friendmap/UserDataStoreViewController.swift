//
//  UserDataStoreViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/08/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User: Codable {
    //user構造体
    let displayName: String
    let createdTime: Date?
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case createdTime = "created_time"
        case uid
    }
}

final class UserDataStore{
    
//    /// 引数で渡されたuserオブジェクトをFirestoreに保存します
//    /// - Parameters:
//    ///   - user: 保存するユーザー情報
//    ///   - completion: 保存処理の成否を返すクロージャー
//    static func createUser(user: User, completion: @escaping (_ success: Bool) -> Void) {
//        let db = Firestore.firestore()
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .secondsSince1970
//        //userオブジェクトをJSONデータに変換
//        let data = try! encoder.encode(user)
//        //JSONオブジェクトを辞書に変換
//        var dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//        dictionary["created_time"] = dateToTimestamp(user.createdTime)
//        db.collection("users").document(user.uid).setData(dictionary) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(false)
//                return
//            }
//            completion(true)
//        }
    }
    
    /// 現在のユーザーの情報を更新します
    /// - Parameters:
    ///   - displayName: 更新後の表示名
    ///   - completion: 更新処理の成否を返すクロージャー
func updateUser(displayName: String, completion: @escaping (_ success: Bool) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        userRef.updateData(["display_name": displayName]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Firestoreから現在のユーザーの情報を取得します。
    /// - Parameters:
    ///   - completion: 取得したユーザー情報を返すクロージャー
func fetchUserData(completion: @escaping (_ user: User?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        userRef.getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshot = snapshot, snapshot.exists else {
                completion(nil)
                return
            }
            do {
                let data = snapshot.data()
                let user = try JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: data))
                completion(user)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    //DateからTimestampに変換
//    static func dateToTimestamp(_ date: Date?) -> Timestamp? {
//        guard let date = date else { return nil }
//        return Timestamp(date: date)
//    }
