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
    
    @IBOutlet var titleLabel: UILabel!
    
    var cnt = 0
    var timer:Timer?
    let bluetoothManager = BluetoothManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if bluetoothManager.isConnected == false {
            setup()
        }
    }
    
    func setup(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
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
        bluetoothManager.delegate = self
        bluetoothManager.setup()
    }
    
    func back(){
        bluetoothManager.delegate = nil
        if let presentationController = presentationController{
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
        self.dismiss(animated: true)
    }
}

extension ConnectViewController: BluetoothManagerDelegate {
    func connected() {
        titleLabel.text = "キャリブレーションしています\n動かさないでください"
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            self.bluetoothManager.calibrate()
            self.titleLabel.text = "ペアリングが完了しました"
            self.timer?.invalidate()
            self.Circle1.isHidden = false
            self.Circle2.isHidden = false
            self.Circle3.isHidden = false
        })
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { _ in
            self.back()
        })
    }
    
    func dataUpdated(rawData: RawData) {
        print("dataUpdated")
    }
    
    func endConnecting() {
        print("EndConnecting")
    }
}
