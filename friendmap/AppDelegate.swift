//
//  AppDelegate.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/05/27.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//Firestore のインスタンスを初期化
//    let db = Firestore.firestore()
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey("AIzaSyD9f2_8Y-_VxIVuQd-L4sNhT-0swGg7SUM")
        GMSServices.provideAPIKey("AIzaSyD9f2_8Y-_VxIVuQd-L4sNhT-0swGg7SUM")
        
        GooglePlacesManager.shared.setUp()
        
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
    
    


}

