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
        let rawData: [Int] = [72, 74, 70, 69, 68, 70, 71]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemOrange]
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 5
        dataSet.mode = .linear
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        
        lineChartView.setScaleEnabled(false)
        lineChartView.highlightPerDragEnabled = false
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelTextColor = .systemGray3
        lineChartView.xAxis.gridColor = .systemGray3
        lineChartView.xAxis.valueFormatter = LineChartFormatter()
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)

        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.labelTextColor = .systemGray3
        lineChartView.rightAxis.gridColor = .systemGray3
        lineChartView.rightAxis.labelFont = .boldSystemFont(ofSize: 14)

        lineChartView.legend.enabled = false
        
        lineChartView.animate(xAxisDuration: 2, easingOption: .linear)
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

public class LineChartFormatter: NSObject, AxisValueFormatter{
    let dayNames: [String]! = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri","Sat"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 0 -> Jan, 1 -> Feb...
        return dayNames[Int(value)]
    }
}
