//
//  GameViewController.swift
//  NoraONI
//
//  Created by AGA TOMOHIRO on 2020/09/23.
//

import UIKit

class DemonViewController: UIViewController {
    //timerの時間(1時間,10分,10秒)
    var time: [Int] = [00,10,00]
    //さっき作ったlabelを紐づける
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //labelの表示を初期化
        let count = time[0]*60+time[1]
        timeLabel.text = String(format: "%02d", time[0]) + ":" + String(format: "%02d", time[1]) + ":" + String(format: "%02d", time[2])
        //1秒ごとに時間をtimerメソッドを呼び出す。
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self, selector:#selector(Atimer) , userInfo: nil, repeats: false)
    }
    
    @objc func Atimer(){
        performSegue(withIdentifier: "DemonResultView", sender: nil)
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
    
}
