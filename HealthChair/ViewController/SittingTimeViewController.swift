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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "座った時間"
    }

    func setUpGraph(rawData: [Float]){
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
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
    
    func getRequest() -> [Int] {
        let apiManager = APIManager()
        apiManager.requestSitting(params: "/sitting/today",completion: { data in
            DispatchQueue.main.async {
                self.setUpGraph(rawData: data)
                let sum = data.reduce(0,+)
                self.hourLabel.text = String(Int(sum) / 60)
                self.minuteLabel.text = String(Int(sum) % 60)
            }
            print("hello",data)
        })
        
        guard let url = Bundle.main.url(forResource: "sample_dairy", withExtension: "json") else { fatalError("ファイルが見つからない") }
        guard let data = try? Data(contentsOf: url) else { fatalError("ファイル読み込みエラー") }
        let decoder = JSONDecoder()
        guard let response = try? decoder.decode(DairyData.self, from: data) else { fatalError("JSON読み込みエラー") }
        return response.datas
    }
    
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
