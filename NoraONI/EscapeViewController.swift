//
//  EscapeViewController.swift
//  NoraONI
//
//  Created by AGA TOMOHIRO on 2020/09/24.
//

import UIKit
import CoreLocation

class EscapeViewController: UIViewController {
    var time: [Int] = [10,00,00]
    @IBOutlet weak var timeLabel: UILabel!
    let arcLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    var rad: CGFloat = 100.0
    var Angle = CGFloat()
    // ロケーションマネージャ
        var locationManager: CLLocationManager!
        // コンパスの針
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        let count = time[0]*60+time[1]
        timeLabel.text = String(format: "%02d", time[0]) + ":" + String(format: "%02d", time[1]) + ":" + String(format: "%02d", time[2])
        //1秒ごとに時間をtimerメソッドを呼び出す。
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self, selector:#selector(Atimer) , userInfo: nil, repeats: false)
        
        // ロケーションマネージャ生成
                locationManager = CLLocationManager()
                // ロケーションマネージャのデリゲート設定
                locationManager.delegate = self
                // 角度の取得開始
                locationManager.startUpdatingHeading()
  drawArc()
        
        

    }
    
    @objc func Atimer(){
        performSegue(withIdentifier: "EscapeResultView", sender: nil)
    }
    
    @objc func timer(){
        if (time[0] == 0 && time[1] == 0 && time[2] == 0) {
            timeLabel.text = "終了"
        } else {
            if time[2] > 0 {
                //秒数が0以上の時秒数を-1
                time[2] -= 1
            } else {
                //秒数が0の時
                time[2] += 99
                if time[1] > 0 {
                    //分が0以上の時、分を-1
                    time[1] -= 1
                } else {
                    //分が０の時、+59分、時間-1
                    time[1] += 59
                    time[0] -= 1
                }
            }
            timeLabel.text = String(format: "%02d", time[0]) + ":" + String(format: "%02d", time[1]) + ":" + String(format: "%02d", time[2])
        }
    }
    
    func drawArc() {
        let angle: CGFloat = CGFloat(2.0 * Double.pi / 6)
        let start: CGFloat = CGFloat(-Double.pi / 2.0) - angle  // 開始の角度
        let end: CGFloat = start - angle // 終了の角度
        let path: UIBezierPath = UIBezierPath()
        let arcCenter: CGPoint = CGPoint(x: 50, y: 50)

        let circlePath: UIBezierPath = UIBezierPath();
        circlePath.move(to: arcCenter)
        circlePath.addArc(withCenter: arcCenter,
                          radius: rad,
                          startAngle: 0,
                          endAngle: CGFloat(-Double.pi * 2.0),
                          clockwise: false)

        circleLayer.frame = CGRect(x: self.view.center.x-50, y: self.view.center.y-50, width: 100, height: 100)
        circleLayer.fillColor = UIColor.lightGray.cgColor
        circleLayer.path = circlePath.cgPath

        self.view.layer.addSublayer(circleLayer)

        path.move(to: arcCenter)
        path.addArc(withCenter: arcCenter,
                    radius: rad,
                    startAngle: start,
                    endAngle: end,
                    clockwise: false)

        arcLayer.frame = CGRect(x: self.view.center.x-50, y: self.view.center.y-50, width: 100, height: 100)
        arcLayer.fillColor = UIColor.black.cgColor
        arcLayer.path = path.cgPath
        self.view.layer.addSublayer(arcLayer)
    }
}

extension EscapeViewController:CLLocationManagerDelegate{
    // 角度の更新で呼び出されるデリゲートメソッド
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            let oniAngle = CGFloat(60 - 90)
            // コンパスの針の方向計算
            let tabAngle = CGFloat(newHeading.magneticHeading)
            
            if oniAngle > tabAngle{
                Angle = oniAngle - tabAngle
            }else{
                Angle = CGFloat(360) - tabAngle + oniAngle
                print(Angle)
            }
            
            print(Angle)
           rotateArc(angle: Angle)
        }
    
    
    private func rotateArc(angle:CGFloat) {
        var fromVal: CGFloat = angle
        var toVal: CGFloat = angle

            fromVal = -angle
            toVal = -angle


        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.fromValue = fromVal
        animation.toValue = toVal

        arcLayer.add(animation, forKey: "animation")
    }
}

