//
//  MainroomViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/07/29.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseFirestore
import FirebaseAuth


class MainroomViewController: UIViewController, GMSMapViewDelegate, UISearchResultsUpdating {
    
    
// Firestoreのデータベースを参照
//    let db = Firestore.firestore()
//    var selectedTags: [String] = []
//    var userManager = UserManager()
//    var tagNames = [String]()


    
    var mapView: GMSMapView!
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    
    var editingMarker: GMSMarker?
    var markerTextField: UITextField!
    var contentTextView: UITextView!
    
    // 現在地の座標を格納する変数
        private var current: CLLocationCoordinate2D?
    
    // Locationの取得に必要なManager
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // ViewControllerでCLLocationManagerDelegateのメソッドを利用できるように
        manager.delegate = self
        return manager
        
    }()
    
    
    
//TextViewのhitokotoをUserDefaults保存
//    var hitokotoSaveData: UserDefaults = UserDefaults.standard
    
    
    let searchVC = UISearchController(searchResultsController: ResultViewController())
    
    
//        private lazy var mapView: GMSMapView = {
//               // 東京を表示する緯度・経度・カメラZoom値を設定
//               let camera = GMSCameraPosition.camera(
//                   withLatitude: 36.0,
//                   longitude: 140.0,
//                   zoom: 8.0)
//               let view = GMSMapView.map(withFrame: view.frame, camera: camera)
//               view.isMyLocationEnabled = true // コレ
//               return view
//           }()
//
    //    let searchVC = UISearchController(searchResultsController: nil)
    
    @IBOutlet var returnButton: UIButton!
    
    
    
    var mainroom: RoomData!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Maps"
        
//        mapView.delegate = self
        
        navigationController?.navigationBar.backgroundColor = .clear
        searchVC.searchBar.backgroundColor = .clear
        searchVC.searchBar.searchTextField.backgroundColor = .white
        
//        searchVC.searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
        // Locationを取得開始する
                locationManager.startUpdatingLocation()
        
        
        
        
        let camera = GMSCameraPosition.camera(
            withLatitude: -33.86,
            longitude: 151.20,
            zoom: 6.0)
        
        
        
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        //右下のボタンを追加
        mapView.settings.myLocationButton = true
        
        //現在地表示
        mapView.isMyLocationEnabled = true
        
        
        
        //Creates a marker in the center of the map
        let marker = GMSMarker()
        
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        
        
        //マーカーのアイコンをイメージにする
                marker.icon = self.imageWithImage(image: UIImage(named: "pinimage")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
        
        marker.tracksViewChanges = true
        marker.map = mapView
        
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        
        self.mapView.delegate = self
        
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        // viewにMapViewを追加？
                view.addSubview(mapView)
        
        // 長押しのUIGestureRecognizerを生成.
                var myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: Selector(("recognizeLongPress:")))
//        myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
                
        // MapViewにUIGestureRecognizerを追加.
        mapView.addGestureRecognizer(myLongPress)
        
        
        // Firestoreからタグを取得する
//        userManager.fetchTags { [weak self] tagNames in
//            self?.tagNames = tagNames
//            self?.buildForm()
//        }
    }
    
    /*
       長押しを感知した際に呼ばれるメソッド.
       */
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        // 長押しの最中に何度もピンを生成しないようにする.
        if sender.state != UIGestureRecognizer.State.began {
                       return
                   }
        
        // 長押しした地点の座標を取得.
//        var location = sender.location(in: mapView)
        
        
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
        
        editingMarker = marker
//        showMarkerEditingView()
        
//        showTitleInputAlert()
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
    
//    キーボード閉じる
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    

    
//    func showMarkerEditingView() {
//            markerTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
//            markerTextField.text = editingMarker?.title
//            markerTextField.backgroundColor = UIColor.white
//            markerTextField.delegate = self
//
//            view.addSubview(markerTextField)
//        }
    
    // アラートを表示してユーザーがタイトルを入力できるようにする
//        func showTitleInputAlert() {
//            let alertController = UIAlertController(title: "マーカータイトルの編集", message: nil, preferredStyle: .alert)
//            alertController.addTextField { textField in
//                textField.placeholder = "新しいタイトル"
//            }
//
//            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
//            let saveAction = UIAlertAction(title: "保存", style: .default) { [weak self] _ in
//                if let textField = alertController.textFields?.first, let newTitle = textField.text {
//                    self?.marker.title = newTitle
//                }
//            }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return self.customInfoWindow
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 140
    }
    
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        
//        GMSServices.provideAPIKey("AIzaSyCo8DwtL8P32qoP0b8A_EzsNsM2oNOsbjs")
//        
//        
//        return true
//    }
    
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
        
        print(query)
        resultsVC.delegate = self
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                
            case.failure(let error):
                print("")
                print("")
                print(error)
                print("")
                print("")
            }
        }
    }
    
//    @IBAction func savehitokoto(_ sender: Any) {
//        hitokotoSaveData.set(contentTextView.text, forKey: "content")
//
//        let alert: UIAlertController = UIAlertController(title: "保存", message: "一言の保存が完了しました", preferredStyle: .alert)
        
//        OKボタンで自動的に前画面に戻る
//        alert.addAction(
//            UIAlertAction(title: "OK",
//                          style: .default
//                          handler: { action in
//                          self.navigationController?.popViewController(animated: true)
//                         })

//    }
    
        }

extension MainroomViewController: ResultViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true)
        
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinates.latitude,
            longitude: coordinates.longitude,
            zoom: 60.0)
        
        let marker = GMSMarker()
        
        //ピンの色変更
        //        marker.icon = GMSMarker.markerImage(with: .black)
        
        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        //吹き出しのメインタイトル
        marker.title = "メインタイトル"
        //吹き出しのサブタイトル
//        marker.snippet = "サブタイトル"
        //マーカーのアイコンをイメージにする
                marker.icon = self.imageWithImage(image: UIImage(named: "pinimage")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
        
        marker.tracksViewChanges = true
        marker.map = mapView
        
        mapView.camera = camera
        
        // Add a map pin
//                let pin = MKPointAnnotation()
//                pin.coordinate = coordinates
//                mapView.addAnnotation(pin)
//                mapView.setRegion(
//                    MKCoordinateRegion(
//                        center: coordinates,
//                        span: MKCoordinateSpan(
//                            latitudeDelta: 0.2,
//                            longtitudeDelta: 0.2
//                        )),
//                    animated: true
//                )
        
        
        
    }
    
//    マーカーがタップされたときに呼ばれるデリゲートメソッド
//        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//            showTitleInputAlert()
//            return true
//        }
    
//     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
    
}

//extension MainroomViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        editingMarker?.title = textField.text
//        textField.removeFromSuperview()
//    }
//}


extension MainroomViewController: CLLocationManagerDelegate {
    // 現在地が更新された時にはしる処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        current = locations.first?.coordinate
    }
}

