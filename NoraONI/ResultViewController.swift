//
//  ResultViewController.swift
//  NoraONI
//
//  Created by AGA TOMOHIRO on 2020/09/23.
//

import UIKit


//結果を表示する関数
class ResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    ルーム作成の部屋に戻るボタン
    @IBAction func resetButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
