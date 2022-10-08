//
//  MainViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/06.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var sittingCardView: UIView!
    @IBOutlet var weightCardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
    }

    func setup(){
        sittingCardView.layer.cornerRadius = 10
        weightCardView.layer.cornerRadius = 10
    }
    
    @IBAction func showSittingTimeView(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.present(secondViewController, animated: true, completion: nil)

    }

}

