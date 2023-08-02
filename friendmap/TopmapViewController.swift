//
//  TopmapViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/07/12.
//

import UIKit
import GoogleMaps

class TopmapViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    
    let menuView = TopmenuViewController()
    
    let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Float.random(in: -90...90)), longitude:CLLocationDegrees(Float.random(in: -180...180)), zoom: 10.0)
    
    //    マップを移動
    //        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Float.random(in: 0...1)), CLLocationDegrees(Float.random(in: 0...1)))
    //        var region: MKCoordinateRegion = map.region

    //        region.center = location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GMSServices.provideAPIKey("AIzaSyCo8DwtL8P32qoP0b8A_EzsNsM2oNOsbjs")
        
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
//        self.view = mapView
//        view.addSubview(mapView)
//        view.sendSubviewToBack(mapView)
        
        menuView.delegate = self
        
        self.view.addSubview(menuView.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

extension TopmapViewController: MenuDelegate {
    func menuChanged() {
        
        //マップを移動
//        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(Float.random(in: 0...1)), CLLocationDegrees(Float.random(in: 0...1)))
//        var region: MKCoordinateRegion = map.region
//
//        region.center = location
    }
}
