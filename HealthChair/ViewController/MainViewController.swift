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
    
    @IBOutlet var statusCardView: UIView! {
        didSet {
            statusCardView.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var circularview: MBCircularProgressBarView!
    
    @IBOutlet var sittingHourLabel: UILabel!
    @IBOutlet var sittingMinuteLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    @IBOutlet var circleImageView: UIImageView!
    
    var sittingData = SittingData()
    var weightData = WeightData()
    
    var bluetoothManager = BluetoothManager.shared
    
    var center: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        
//        let content = UNMutableNotificationContent()
//        content.title = "タイトル"
//        content.subtitle = "サブタイトル"
//        content.body = "タップしてアプリを開いてください"
//        content.sound = UNNotificationSound.default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//        let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("hello", error.localizedDescription)
//            }
//        }
        navigationItem.backBarButtonItem = .init(title: "概要", style: .plain, target: nil, action: nil)
        center = circleImageView.center
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
        
        Task.detached{
            do {
                let response = try await self.sittingData.getAllData()
                await MainActor.run {
                    self.sittingData = response
                    self.sittingHourLabel.text = String(Int(self.sittingData.dailySum * 60) / 60)
                    self.sittingMinuteLabel.text = String(Int(self.sittingData.dailySum * 60) % 60)
                    // print(self.sittingData)
                }
            } catch {
                print("error occured")
            }
        }
        Task.detached{
            do {
                let response = try await self.weightData.getAllData()
                await MainActor.run {
                    self.weightData = response
                    self.weightLabel.text = String(Int(self.weightData.dailyMean))
                    print(response)
                }
            } catch {
                print("error occured")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("come back")
        bluetoothManager.delegate = self
        setup()
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
        let storyboard: UIStoryboard = UIStoryboard(name: "SettingViewController", bundle: nil)
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.show(settingViewController, sender: nil)
    }
    
    @IBAction func calibrateTapped(_ sender: UITapGestureRecognizer){
        bluetoothManager.calibrate()
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
        let weight = CGFloat(rawData.w0 + rawData.w1 + rawData.w2 + rawData.w3)
        circularview.value = weight
        let sum = rawData.w0 + rawData.w1 + rawData.w2 + rawData.w3 + 25.0
        let radius: Float = 50.0
        let x = (rawData.w0 + rawData.w1 - rawData.w2 - rawData.w3) * radius / sum
        let y = (rawData.w0 - rawData.w1 - rawData.w2 + rawData.w3) * radius / sum
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.circleImageView.center = CGPoint(x: self.center.x + CGFloat(x), y: self.center.y + CGFloat(y))
        }, completion: nil)
        // label.text = String(rawData.w0 + rawData.w1 + rawData.w2 + rawData.w3) + "kg"
    }
    
}
