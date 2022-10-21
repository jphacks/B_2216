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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraph()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "座った時間"
    }

    func setUpGraph(){
        let rawData: [Int] = getRawData()
        // let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40, 0, 0, 0, 0, 0, 20, 50, 70, 30, 60, 90, 40, 0, 0, 0, 0, 0]
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
        
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.labelTextColor = .systemGray3
        barChartView.rightAxis.gridColor = .systemGray3
        barChartView.rightAxis.labelFont = .boldSystemFont(ofSize: 14)
        
        barChartView.legend.enabled = false
        
        barChartView.animate(yAxisDuration: 1, easingOption: .easeOutBack)
    }
    
    func getRawData() -> [Int] {
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
