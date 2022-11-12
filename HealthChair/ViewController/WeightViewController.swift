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
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var weightLabel: UILabel!
    
    var weightData: WeightData!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segmentedControl.selectedSegmentIndex = Term.weekly.rawValue
        weightLabel.text = String(Int(weightData.weeklyMean))
        setUpGraph(rawData: weightData.weeklyData, xFormatter: Formatter.WeeklyFormatter(), yFormatter: Formatter.KiloGramFormatter())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "体重"
    }
    
    func setUpGraph<T:AxisValueFormatter,U:AxisValueFormatter>(rawData: [WeightUnit], xFormatter:T, yFormatter: U){
        let floatData: [Float] = rawData.map { $0.value }
        let entries = floatData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) } .filter { $0.y != 0 }
        print(entries)
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemOrange]
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 5
        dataSet.mode = .linear
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.xAxis.valueFormatter = xFormatter
        lineChartView.data = data
        
        lineChartView.setScaleEnabled(false)
        lineChartView.highlightPerDragEnabled = false
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelTextColor = .systemGray3
        lineChartView.xAxis.gridColor = .systemGray3
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)

        lineChartView.leftAxis.labelTextColor = .clear
        lineChartView.rightAxis.labelTextColor = .systemGray3
        lineChartView.rightAxis.gridColor = .systemGray3
        lineChartView.rightAxis.labelFont = .boldSystemFont(ofSize: 14)
        lineChartView.rightAxis.valueFormatter = yFormatter

        lineChartView.legend.enabled = false
        
        lineChartView.animate(xAxisDuration: 2, easingOption: .linear)
    }
    
    func updateUI(selectedType: Term){
        switch selectedType{
        case .daily:
            setUpGraph(
                rawData: weightData.dailyData,
                xFormatter: Formatter.DailyFormatter(),
                yFormatter: Formatter.KiloGramFormatter()
            )
            weightLabel.text = String(Int(weightData.dailyMean))
        case .weekly:
            setUpGraph(
                rawData: weightData.weeklyData,
                xFormatter: Formatter.WeeklyFormatter(),
                yFormatter: Formatter.KiloGramFormatter()
            )
            weightLabel.text = String(Int(weightData.weeklyMean))
        case .monthly:
            setUpGraph(
               rawData: weightData.monthlyData,
               xFormatter: Formatter.MonthlyFormatter(),
               yFormatter: Formatter.KiloGramFormatter()
            )
            weightLabel.text = String(Int(weightData.monthlyMean))
        }
    }
    
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        let type = Term(rawValue: sender.selectedSegmentIndex) ?? .daily
        updateUI(selectedType: type)
        print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
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
