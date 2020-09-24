//
//  SettingRuleViewController.swift
//  NoraONI
//
//  Created by AGA TOMOHIRO on 2020/09/23.
//

import UIKit
import MapKit

class SettingRuleViewController: UIViewController {
    
    var Lo1 = 0.0
    var La1 = 0.0
    var Lo2 = 0.0
    var La2 = 0.0
    
    var longtitudeNow = ""
    var latitudeNow = ""
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var position1: RegistButton!
    @IBOutlet weak var position2: RegistButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        position2.isEnabled = false
        position2.alpha = 0.3
        mapView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi / 180.0))
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        // ロケーションマネージャのセットアップ
        sequenceTimer()
        setupLocationManager()
    }
    enum actionTag: Int {
        case action1 = 0
        case action2 = 1
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    
    @IBAction func getPosition(_ sender: Any) {
        if let button = sender as? UIButton {
            if let tag = actionTag(rawValue: button.tag) {
                switch tag {
                case .action1:
                    let longtitude1 = longtitudeNow
                    Lo1 = Double(longtitude1) ?? 0.0
                    let latitude1 = latitudeNow
                    La1 = Double(latitude1) ?? 0.0
                    changeButton(B1: position1, B2: position2)
                    setpin(la: La1, lo: Lo1)
                    label1.text = longtitude1 + "と" + latitude1
                    print("\(longtitude1),\(latitude1)")
                case .action2:
                    let longtitude2 = longtitudeNow
                    Lo2 = Double(longtitude2) ?? 0.0
                    let latitude2 = latitudeNow
                    La2 = Double(latitude2) ?? 0.0
                    changeButton(B1: position2, B2: position1)
                    setpin(la: La2, lo: Lo2)
                    label2.text = longtitude2 + "と" + latitude2
                    print("\(longtitude2),\(latitude2)")
                }
            }
        }
        
    }
    func changeButton(B1:UIButton,B2:UIButton){
        B1.isEnabled = false
        B2.isEnabled = true
        B1.alpha = 0.3
        B2.alpha = 1.0
    }
    func setpin(la:Double,lo:Double){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(la, lo)
        annotation.title = "position1"
        self.mapView.addAnnotation(annotation)
    }
    
    
    func sequenceTimer(){
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            //             String(format:"%02d", minute)
            let La = CLLocationDegrees(Double(latitudeNow) ?? 0.0)
            let Lo = CLLocationDegrees(Double(longtitudeNow) ?? 0.0)
            let coordinate = CLLocationCoordinate2D(latitude: La, longitude: Lo)
            let span = MKCoordinateSpan(latitudeDelta:  0.008983148616, longitudeDelta: 0.010966382364)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.region = region
        }
    }
    
    
    /// ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        // 権限をリクエスト
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    /// アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
//        ここにフィールドの範囲を送るメソッドを立てる
        print(Lo1,Lo1,La2,Lo2)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingRuleViewController: CLLocationManagerDelegate {
    
    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else{return}
        guard let longitude = location?.coordinate.longitude else{return}
        // 位置情報を格納する
        self.latitudeNow = String(latitude)
        self.longtitudeNow = String(longitude)
    }
    
    
}
