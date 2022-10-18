//
//  WeightViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/16.
//

import UIKit
import Charts

class WeightViewController: UIViewController {
    @IBOutlet var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraph()
    }
    
    func setUpGraph(){
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemOrange]
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based , you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
