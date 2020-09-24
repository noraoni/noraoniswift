//
//  CreateMemberViewController.swift
//  NoraONI
//
//  Created by AGA TOMOHIRO on 2020/09/23.
//

import UIKit
import Starscream

//ImageのUIを決定する関数
class RegistImage:UIImageView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

//登録ボタン系のUIを決定する関数
class RegistButton:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

class CreateMemberViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBAction func AddImage(_ sender: Any) {
        activeCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
//    カメラを起動したりアルバムから画像を取得したりする関数
    func activeCamera(isDeletable: Bool?=nil,
                                 deleteAction:((UIAlertAction) -> Void)?=nil) {
        let alert: UIAlertController = UIAlertController(title: "", message: "選択してください", preferredStyle: .actionSheet)
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラで撮影", style: .default, handler:{ [weak self]
                (action: UIAlertAction!) -> Void in
            guard let this = self else { return }
            let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = this
                this.present(cameraPicker, animated: true, completion: nil)
            }
        })
    
    let galleryAction: UIAlertAction = UIAlertAction(title: "アルバムから選択", style: .default, handler:{ [weak self]
        (action: UIAlertAction!) -> Void in
        guard let this = self else { return }
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let libraryPicker = UIImagePickerController()
            libraryPicker.sourceType = sourceType
            libraryPicker.delegate = this
            this.present(libraryPicker, animated: true, completion: nil)
        }
    })

    let deleteAction = UIAlertAction(title: "写真を削除", style: .default, handler: deleteAction)
    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
        (action: UIAlertAction!) -> Void in
        print("キャンセル")
    })
    alert.addAction(cancelAction)
    alert.addAction(cameraAction)
    alert.addAction(galleryAction)
    if isDeletable == true {
        alert.addAction(deleteAction)
    }
    present(alert, animated: true, completion: nil)
}
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.image.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
//    ここにユーザーの名前と画像が登録されます。
    @IBAction func RegistUser(_ sender: Any) {
        guard let Cname = name.text else {return}
        var request = URLRequest(url: URL(string: "http://b3d8689375d5.ngrok.io/")!)
        let socket = WebSocket(request: request)
        request.timeoutInterval = 5
        socket.delegate = self
        socket.connect()
        
        socket.write(string: Cname)
        name.text = ""
        
    }
    
    
}

extension CreateMemberViewController:WebSocketDelegate{
    func didReceive(event: WebSocketEvent, client: WebSocket) {

        var isConnected = Bool()
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
        case .error( _):
                isConnected = false
            }
    }
}
