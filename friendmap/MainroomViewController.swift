//
//  MainroomViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/07/29.
//

import UIKit
import GoogleMaps

class MainroomViewController: UIViewController {
//    private lazy var mapView: GMSMapView = {
//           // 東京を表示する緯度・経度・カメラZoom値を設定
//           let camera = GMSCameraPosition.camera(
//               withLatitude: 36.0,
//               longitude: 140.0,
//               zoom: 8.0)
//           let view = GMSMapView.map(withFrame: view.frame, camera: camera)
//           view.isMyLocationEnabled = true // コレ
//           return view
//       }()
   
    
    @IBOutlet var returnButton: UIButton!
    
    var mainroom: RoomData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
                let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
                self.view.addSubview(mapView)

                // Creates a marker in the center of the map.
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//                marker.title = "Sydney"
//                marker.snippet = "Australia"
//                marker.map = mapView
//
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
//        view.addSubview(mapView)

        // Do any additional setup after loading the view.
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.

            GMSServices.provideAPIKey("AIzaSyCo8DwtL8P32qoP0b8A_EzsNsM2oNOsbjs")
        

            return true
        }
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
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
