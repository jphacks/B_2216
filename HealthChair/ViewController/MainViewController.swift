//
//  MainViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/06.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var sittingCardView: UIView!
    @IBOutlet var weightCardView: UIView!
    @IBOutlet var realtimeCardView: UIView!
    
    @IBOutlet var label: UILabel!
    
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
        label.text = String(rawData.w0 + rawData.w1 + rawData.w2 + rawData.w3) + "kg"
    }
    
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("come back")
        bluetoothManager.delegate = self
    }
}
