//
//  SettingViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/11/12.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var tableview: UITableView!{
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
        }
    }
    
    var bluetoothManager = BluetoothManager.shared
    
    let texts = ["ペアリング", "Wifi設定"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
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

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            if !bluetoothManager.isConnected {
                let storyboard: UIStoryboard = UIStoryboard(name: "ConnectViewController", bundle: nil)
                let connectViewController = storyboard.instantiateViewController(withIdentifier: "ConnectViewController") as! ConnectViewController
                connectViewController.presentationController?.delegate = self
                self.present(connectViewController, animated: true)
            }
            break
        case 1:
            if !bluetoothManager.isWifi && bluetoothManager.isConnected {
                let storyboard: UIStoryboard = UIStoryboard(name: "SettingWifiViewController", bundle: nil)
                let settingWifiViewController = storyboard.instantiateViewController(withIdentifier: "SettingWifiViewController") as! SettingWifiViewController
                settingWifiViewController.presentationController?.delegate = self
                self.present(settingWifiViewController, animated: true)
            }
            break
        default:
            print("error")
            break
        }
        tableview.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingTableCell
        cell.titleLabel.text = texts[indexPath.row]
        if indexPath.row == 0 {
            cell.statusLabel.text = bluetoothManager.isConnected ? "接続済み" : "未接続"
        } else if indexPath.row == 1 {
            cell.statusLabel.text = bluetoothManager.isWifi ? "接続済み" : "未接続"
        }
        return cell
    }

}

extension SettingViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("come back")
        tableview.reloadData()
    }
}
