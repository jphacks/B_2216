//
//  MainViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/06.
//

import UIKit
import MBCircularProgressBar

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var sittingCardView: UIView!
    @IBOutlet var weightCardView: UIView!
    @IBOutlet var realtimeCardView: UIView!
    
    @IBOutlet var label: UILabel!
    @IBOutlet var circularview: MBCircularProgressBarView!
    
    @IBOutlet var sittingHourLabel: UILabel!
    @IBOutlet var sittingMinuteLabel: UILabel!
    @IBOutlet var kilogramLabel: UILabel!
    
    var sittingData = SittingData()
    
    var bluetoothManager = BluetoothManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        
        sittingCardView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.sittingCardViewTapped(_:))))
        
        weightCardView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.weightCardViewTapped(_:))))
        
        navigationItem.backBarButtonItem = .init(title: "概要", style: .plain, target: nil, action: nil)
    }
    
    func setup() {
        sittingCardView.layer.cornerRadius = 16
        weightCardView.layer.cornerRadius = 16
        realtimeCardView.layer.cornerRadius = 16
        
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
                self.sittingHourLabel.text = String(Int(sittingData.dailySum) / 60)
                self.sittingMinuteLabel.text = String(Int(sittingData.dailySum) % 60)
            }
            print(sittingData)
        })
    }

    @objc func sittingCardViewTapped(_ sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SittingTimeViewController", bundle: nil)
        let sittingTimeViewController = storyboard.instantiateViewController(withIdentifier: "SittingTimeViewController") as! SittingTimeViewController
        self.show(sittingTimeViewController, sender: nil)
    }
    
    @objc func weightCardViewTapped(_ sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "WeightViewController", bundle: nil)
        let weightViewController = storyboard.instantiateViewController(withIdentifier: "WeightViewController") as! WeightViewController
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
