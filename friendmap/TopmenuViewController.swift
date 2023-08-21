//
//  ViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/05/27.
//

import UIKit
import GoogleMaps

class TopmenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GMSMapViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    //保存してるデータそれぞれを配列で並べたもの
    var roomArray = [RoomData]()
    
    //多分ルームごとのデータの保存場所
    var selectedroom: RoomData!
    
    private var mapView: GMSMapView!
    
//    let menuView = TopmenuViewController()
    
    
    
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //    }
    
    //一番最初だけ呼び出し
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GMSServices.provideAPIKey("AIzaSyCo8DwtL8P32qoP0b8A_EzsNsM2oNOsbjs")
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Float.random(in: -90...90)), longitude:CLLocationDegrees(Float.random(in: -180...180)), zoom: 10.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
//        menuView.delegate = self
        
        collectionView.delaysContentTouches = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "NewroomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewRoomCell")
        collectionView.register(UINib(nibName: "TopmenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        let nullData = [RoomData]()
        let data = try? JSONEncoder().encode(nullData)
        UserDefaults.standard.register(defaults: ["room": data])
    }
    
    //     アカウントアイコンがタップされたときに実行されるメソッド
        @IBAction func accountButtonTapped() {

            performSegue(withIdentifier: "toAccountDetail", sender: nil)
            
        }
    
    var delegate: TopmenuViewController? = nil
    
    override func viewDidLayoutSubviews() {
//        let layout = UICollectionViewCompositionalLayout()
        
        
        // cellのサイズを設定
//        layout.itemSize = CGSize(width: collectionView.frame.width , height: 450)
//        layout.sectionInset = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
//        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 10
//        layout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = layout
        
//        collectionView.layer.shadowColor = UIColor.gray.cgColor
//        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        collectionView.layer.shadowOpacity = 1.0
//        collectionView.layer.shadowRadius = 10.0
//        collectionView.layer.masksToBounds = false
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                          heightDimension: .fractionalHeight(0.8))
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
        item.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 25) // marginの設定
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
//            config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        
//
        
        
        
        collectionView.collectionViewLayout = layout
        
        
        
        collectionView.dataSource = self
        
        
    }
    
    //画面が表示されるたびに呼び出される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedData = UserDefaults.standard.object(forKey: "room") as? Data, let decoded = try? JSONDecoder().decode([RoomData].self, from: savedData) {
            roomArray = decoded
            
            print(decoded)
            
            collectionView.reloadData()
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "godetail" {
            
            let TopmenuViewController = segue.destination as! MainroomViewController
            TopmenuViewController.mainroom = selectedroom
        }
    }
    
    
    //セクションの中のセルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Float.random(in: -90...90)), longitude:CLLocationDegrees(Float.random(in: -180...180)), zoom: 10.0)
        
        mapView.camera = camera
    }
    
    //セルに表示する内容を記載する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //indexPath.row : 何番目のセルか
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRoomCell", for: indexPath as IndexPath) as! NewroomCollectionViewCell
            
            return cell
        }else {
            //storyboard上のセルを,,生成　storyboardのIdentifierで付けたものをここで設定する
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath as IndexPath) as! TopmenuCollectionViewCell
            
            cell.setupCell(mainTitle: roomArray[indexPath.row - 1].title,
                           mainDate: roomArray[indexPath.row - 1].time,
                           mainImageData: roomArray[indexPath.row - 1].imageData)
            
            
            return cell
        }
    }
    
    
    
    
    // collectionViewのセルをタップした時に呼ばれるメソッド
    
    
    //(セル選択時の処理)
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(indexPath.row)番目の行が選択されました。")
        
        //indexPath.row : 何番目のセルか
        if indexPath.row == 0 {
            //指定の遷移先に遷移する（最低限の処理）
            performSegue(withIdentifier: "newroom", sender: indexPath.row)
            
        }else {

            //指定の遷移先に遷移する（最低限の処理）
                    performSegue(withIdentifier: "godetail", sender: indexPath.row)

        }
//
//        UICollectionView.deselectRow(at: indexPath, animated: true)
// 別の画面に遷移
//        performSegue(withIdentifier: "MainroomViewController", sender: nil)
        
//指定の遷移先に遷移する（最低限の処理）
//        performSegue(withIdentifier: "godetail", sender: indexPath.row)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "godetail" {
//            let MainroomViewController = segue.destination as! MainroomViewController
//            MainroomViewController.index = sender as! Int
//        }
//    }
    
//    @IBAction func showDetailButton() {
//        performSegue(withIdentifier: "showDetailSegue", sender: nil)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetailSegue" {
//            if let indexPath = collectionView.indexPathForSelectedRow {
//                guard let destination = segue.destination as? MainroomViewController else {
//                    fatalError("Failed to prepare DetailViewController.")
//                }
//
//                destination.mainroom = roomArray[indexPath.row]
//            }
//        }
//    }
    
    
    
}

protocol MenuDelegate {
    func menuChanged()
    
//    マップを移動
//        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Float.random(in: 0...1)), CLLocationDegrees(Float.random(in: 0...1)))
//        var region: MKCoordinateRegion = map.region

//        region.center = location
}
