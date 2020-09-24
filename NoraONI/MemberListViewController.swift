//
//  MemberListViewController.swift
//  NoraONI
//
//  Created by AGA TOMOHIRO on 2020/09/23.
//

import UIKit
import PKHUD

class MemberListViewController: UIViewController {
    let tableList = ["AAA","BBB","CCC","DDD"]
    
    @IBOutlet weak var hostButton: RegistButton!
    @IBOutlet weak var memberButton: RegistButton!
    @IBOutlet weak var membersTableView: UITableView!
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }
    
    var count = 0
    @IBAction func startButton(_ sender: Any) {
        if count % 2 == 0{
        performSegue(withIdentifier: "demonView", sender: nil)
            
//            鬼側の判定だった場合移動する仕様
            count += 1
        }else{
        performSegue(withIdentifier: "escapeView", sender: nil)
//            逃げる側の判定だった場合移動する仕様
            count += 1
        }
        
    }
    
    
    //    メンバーを生成するためのボタン
    @IBAction func member(_ sender: Any) {
        let ac = UIAlertController(title: "IDを入力してください！！", message: "ホストで自動生成された６桁のIDを入力", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak ac] (action) -> Void in
            guard let textFields = ac?.textFields else {return}
            if textFields[0].text == ""{
                print("メンバーに入れませんでした")
                HUD.flash(.error,delay: 0.5)
            }else{
                print("AAAAAA")
                HUD.show(.progress,onView: self.view)
                HUD.hide(){(_)in
                    HUD.flash(.success,delay: 1)
                    //                           成功した場合の記述
                    self.hostButton.isEnabled = false
                    self.memberButton.isEnabled = false
                    self.hostButton.alpha = 0.3
                    self.memberButton.alpha = 0.3
                    
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //textfiledの追加
        ac.addTextField(configurationHandler: {(text:UITextField!) -> Void in
        })
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension MemberListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
                                    reuseIdentifier:cellId)
        cell.textLabel?.text = tableList[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.detailTextLabel?.text = String(indexPath.row)
        return cell
    }
    
}
