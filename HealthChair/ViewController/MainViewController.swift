//
//  MainViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/06.
//

import UIKit
import MBCircularProgressBar

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var sittingCardView: UIView! {
        didSet {
            sittingCardView.layer.cornerRadius = 16
            sittingCardView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(self.sittingCardViewTapped(_:))))
        }
    }
    @IBOutlet var weightCardView: UIView! {
        didSet {
            weightCardView.layer.cornerRadius = 16
            weightCardView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(self.weightCardViewTapped(_:))))
        }
    }
    @IBOutlet var realtimeCardView: UIView! {
        didSet {
            realtimeCardView.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var circularview: MBCircularProgressBarView!
    
    @IBOutlet var sittingHourLabel: UILabel!
    @IBOutlet var sittingMinuteLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    var sittingData = SittingData()
    var weightData = WeightData()
    
    var bluetoothManager = BluetoothManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        
        let content = UNMutableNotificationContent()
        content.title = "タイトル"
        content.subtitle = "サブタイトル"
        content.body = "タップしてアプリを開いてください"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("hello", error.localizedDescription)
            }
        }
        
        navigationItem.backBarButtonItem = .init(title: "概要", style: .plain, target: nil, action: nil)
    }
    
    func setup() {
        circularview.isHidden = false
        label.isHidden = true
        
        if bluetoothManager.isConnected {
            circularview.isHidden = false
            label.isHidden = true
        } else {
            circularview.isHidden = true
            label.isHidden = false
        }
        
        sittingData.getAllData(completion: { [weak self] sittingData in
            guard let self = self else { return }
            self.sittingData = sittingData
            DispatchQueue.main.async {
                self.sittingHourLabel.text = String(Int(sittingData.dailySum * 60) / 60)
                self.sittingMinuteLabel.text = String(Int(sittingData.dailySum * 60) % 60)
            }
            print(sittingData)
        })
        weightData.getAllData(completion: { [weak self] weightData in
            guard let self = self else { return }
            self.weightData = weightData
            DispatchQueue.main.async {
                self.weightLabel.text = String(Int(weightData.dailyMean))
            }
            print(weightData)
        })
    }

    @objc func sittingCardViewTapped(_ sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SittingTimeViewController", bundle: nil)
        let sittingTimeViewController = storyboard.instantiateViewController(withIdentifier: "SittingTimeViewController") as! SittingTimeViewController
        sittingTimeViewController.sittingData = sittingData
        self.show(sittingTimeViewController, sender: nil)
    }
    
    @objc func weightCardViewTapped(_ sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "WeightViewController", bundle: nil)
        let weightViewController = storyboard.instantiateViewController(withIdentifier: "WeightViewController") as! WeightViewController
        weightViewController.weightData = weightData
        self.show(weightViewController, sender: nil)
    }
    
    @IBAction func settingButtonTapped(_ sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ConnectViewController", bundle: nil)
        let connectViewController = storyboard.instantiateViewController(withIdentifier: "ConnectViewController") as! ConnectViewController
        connectViewController.presentationController?.delegate = self
        self.present(connectViewController, animated: true)
    }
}

extension MainViewController: BluetoothManagerDelegate {
    func connected() {
        print("connected")
    }
    
    func endConnecting() {
        print("end connecting")
    }
    
    func dataUpdated(rawData: RawData) {
        circularview.value = CGFloat(rawData.w0 + rawData.w1 + rawData.w2 + rawData.w3)
        // label.text = String(rawData.w0 + rawData.w1 + rawData.w2 + rawData.w3) + "kg"
    }
    
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("come back")
        bluetoothManager.delegate = self
        setup()
    }
}
