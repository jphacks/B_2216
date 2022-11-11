//
//  SittingTimeViewController.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/08.
//

import UIKit
import Charts

class SittingTimeViewController: UIViewController {
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var minuteLabel: UILabel!
    
    var sittingData: SittingData!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // getRequest()
        setUpGraph(rawData: sittingData.dailyData)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "座った時間"
    }

    func setUpGraph(rawData: [SittingUnit]){
        let floatData: [Float] = rawData.map{ $0.hours * 60 }
        let entries = floatData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemOrange]
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        barChartView.setScaleEnabled(false)
        barChartView.highlightFullBarEnabled = false
        barChartView.highlightPerDragEnabled = false
        barChartView.highlightPerTapEnabled = false
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .systemGray3
        barChartView.xAxis.gridColor = .systemGray3
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        barChartView.xAxis.valueFormatter = HourFormatter()
        
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.labelTextColor = .systemGray3
        barChartView.rightAxis.gridColor = .systemGray3
        barChartView.rightAxis.labelFont = .boldSystemFont(ofSize: 14)
        barChartView.rightAxis.valueFormatter = MinutesFormatter()
        
        barChartView.legend.enabled = false
        
        barChartView.animate(yAxisDuration: 1, easingOption: .easeOutBack)
    }
    
    func updateUI(){
        self.hourLabel.text = String(Int(sittingData.dailySum * 60) / 60)
        self.minuteLabel.text = String(Int(sittingData.dailySum * 60) % 60)
        setUpGraph(rawData: sittingData.dailyData)
    }
    
//    func getRequest() {
//        let apiManager = APIManager()
//        apiManager.requestSitting(params: "/sitting/today",completion: { data in
//            DispatchQueue.main.async {
//                self.setUpGraph(rawData: data)
//                let sum = data.reduce(0,+)
//                self.hourLabel.text = String(Int(sum) / 60)
//                self.minuteLabel.text = String(Int(sum) % 60)
//            }
//        })
//    }
    
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
    }
}

public class HourFormatter: NSObject, AxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(Int(value)) + ":00"
    }
}

public class MinutesFormatter: NSObject, AxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(Int(value)) + "分"
    }
}
