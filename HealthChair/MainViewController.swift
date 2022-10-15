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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()

        sittingCardView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.sittingCardViewTapped(_:))))
    }

    func setup() {
        sittingCardView.layer.cornerRadius = 10
        weightCardView.layer.cornerRadius = 10
    }

    @objc func sittingCardViewTapped(_ sender: UITapGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SittingTimeViewController", bundle: nil)
        let sittingTimeViewController = storyboard.instantiateViewController(withIdentifier: "SittingTimeViewController") as! SittingTimeViewController
        self.show(sittingTimeViewController, sender: nil)
    }
}
