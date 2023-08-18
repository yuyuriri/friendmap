//
//  NewroomViewController.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/05/29.
//

import UIKit

class NewroomViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate {
    
    var roomArray = [RoomData]()
    
    @IBOutlet var openAlbumButton: UIButton!
    @IBOutlet var roomImageView: UIImageView!
    @IBOutlet var cameraActivationButtonAction: UIButton!
    @IBOutlet var roomTextField: UITextField!
    @IBOutlet var memoTextField: UITextField!
    @IBOutlet var timeDatePicker: UIDatePicker!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
    @IBOutlet var imageLabel: UILabel!
    
    @IBOutlet var customimageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomTextField.delegate = self
        memoTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    

    
    
    
    @IBAction func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    @IBAction func didTouchDowncameraActivationButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.cameraActivationButtonAction.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    @IBAction func didTouchDragExitcameraActivationButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.cameraActivationButtonAction.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction func didTouchUpInsidecameraActivationButton() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 8,
                       options: .curveEaseOut,
                       animations: { () -> Void in
            
            self.cameraActivationButtonAction.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
    }
    
    @IBAction func didTouchDownopenAlbumButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.openAlbumButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    @IBAction func didTouchDragExitopenAlbumButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.openAlbumButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction func didTouchUpInsideopenAlbumButton() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 8,
                       options: .curveEaseOut,
                       animations: { () -> Void in
            
            self.openAlbumButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
    }
    
    @IBAction func cancel() {
        dismiss(animated: true)
        
    }
    
    
    @IBAction func save () {
        //選択された画像をデータに
        let image = roomImageView.image?.jpegData(compressionQuality: 1) ?? UIImage(named: "noimage")!.jpegData(compressionQuality: 1)!
        
        //新しくルームのデータを作る
        let room = RoomData(title: roomTextField.text!, expirationDate: Date(), time: timeDatePicker.date, memo: memoTextField.text!, imageData: image)
        
       
        guard let savedData = UserDefaults.standard.object(forKey: "room") as? Data else {return}
        
        if let decoded = try? JSONDecoder().decode([RoomData].self, from: savedData) {
            
            roomArray = decoded
            
            //今既にあるデータに新しく作ったデータを追加
            roomArray.append(room)
            
            //配列をData型に変換
            let data = try? JSONEncoder().encode(roomArray)
            
            //UserDefaultsに保存
            UserDefaults.standard.set(data, forKey: "room")
        }
        
        dismiss(animated: true)
    }
}

extension NewroomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func cameraActivationButtonAction(_ sender: Any?) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ imagepicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {roomImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView:UITableView, CanEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

