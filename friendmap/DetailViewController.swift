//
//  DetailViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/05/31.
//

import UIKit



class DetailViewController: UIViewController {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
    
    
    let dateFormatter = DateFormatter()

    var roomArray = [RoomData]()
    
    @IBOutlet var roomtitleLabel: UILabel!
    
    @IBOutlet var roomdateLabel: UILabel!
    
    @IBOutlet var roommemoLabel: UILabel!
    
    @IBOutlet var roomImageView: UIImageView!

    var roomData: RoomData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "YY/MM/dd HH:mm"
        
        
        if let savedData = UserDefaults.standard.data(forKey: "room"), let decoded = try? JSONDecoder().decode([RoomData].self, from: savedData) {
            
            roomArray = decoded
            
            
        }
        
        roomData = roomArray[0]
        
        roomtitleLabel.text = roomData.title
        
//        roomdateLabel.text = roomData.expirationDate.yearMonthDateFormat
        
//        roomImageView.image = UIImage(data: roomData.imageData)

        roommemoLabel.text = roomData.memo
        
        roomdateLabel.text =  dateFormatter.string(from: roomData.time)
        
        
        print(roomData)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
}
