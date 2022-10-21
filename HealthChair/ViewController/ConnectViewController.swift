//
//  ConnectViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/19.
//

import UIKit

class ConnectViewController: UIViewController {
    
    @IBOutlet var Circle1: UIView!
    @IBOutlet var Circle2: UIView!
    @IBOutlet var Circle3: UIView!
    
    var cnt = 0
    let bluetoothManager = BluetoothManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
            switch self.cnt % 8 {
            case 0:
                self.Circle1.isHidden = true
                self.Circle2.isHidden = true
                self.Circle3.isHidden = true
                break
            case 2:
                self.Circle1.isHidden = false
                break
            case 3:
                self.Circle2.isHidden = false
                break
            case 4:
                self.Circle3.isHidden = false
                break
            default:
                break
            }
            self.cnt += 1
        })
        
        bluetoothManager.setup()
    }
}
