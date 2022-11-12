//
//  SettingWifiViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/11/12.
//

import UIKit

class SettingWifiViewController: UIViewController {
    @IBOutlet var ssidTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendClicked(){
        BluetoothManager.shared.sendWifi(ssid: "TP-Link_0338", password: "09968035")
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
