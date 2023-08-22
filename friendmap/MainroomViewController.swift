//
//  MainroomViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/07/29.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MainroomViewController: UIViewController, GMSMapViewDelegate, UISearchResultsUpdating {
   
    var mapView: GMSMapView!
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    
    
    let searchVC = UISearchController(searchResultsController: ResultViewController())
   
    
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
   
//    let searchVC = UISearchController(searchResultsController: nil)
    
    @IBOutlet var returnButton: UIButton!
    

    
    var mainroom: RoomData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Maps"
        
        
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

//Creates a marker in the center of the map.
        let marker = GMSMarker()
        
//ピンの色変更
//        marker.icon = GMSMarker.markerImage(with: .black)
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        
//吹き出しのメインタイトル
        marker.title = "メインタイトル"
//吹き出しのサブタイトル
        marker.snippet = "サブタイトル"
//マーカーのアイコンをイメージにする
        marker.icon = self.imageWithImage(image: UIImage(named: "camera_1")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        
        marker.tracksViewChanges = true
        marker.map = mapView
        
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
//        view.addSubview(mapView)

        // Do any additional setup after loading the view.
    }
    
    //ピンの縮尺を変更する
        func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            NSLog("marker was tapped")
            tappedMarker = marker

            let position = marker.position
            mapView.animate(toLocation: position)
            let point = mapView.projection.point(for: position)
            let newPoint = mapView.projection.coordinate(for: point)
            let camera = GMSCameraUpdate.setTarget(newPoint)
            mapView.animate(with: camera)

            let opaqueWhite = UIColor(white: 1, alpha: 0.85)
            customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
            customInfoWindow?.layer.cornerRadius = 8
            customInfoWindow?.center = mapView.projection.point(for: position)
            mapView.addSubview(customInfoWindow!)
            return false
         }
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            return UIView()
        }
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            customInfoWindow?.removeFromSuperview()
        }
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            let position = tappedMarker?.position
            customInfoWindow?.center = mapView.projection.point(for: position!)
            customInfoWindow?.center.y -= 140
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
    

    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultViewController else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
            
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }

}

extension MainroomViewController: ResultViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        
        
        
        // Add a map pin
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinates
//        mapView.addAnnotation(pin)
//        mapView.setRegion(
//            MKCoordinateRegion(
//                center: coordinates,
//                span: MKCoordinateSpan(
//                    latitudeDelta: 0.2,
//                    longtitudeDelta: 0.2
//                )),
//            animated: true
//        )
    }
    
    
}
