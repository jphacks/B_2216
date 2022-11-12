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
    @IBOutlet var sumOrMeanLabel: UILabel!
    
    @IBOutlet var commentCardView: UIView! {
        didSet {
            commentCardView.layer.cornerRadius = 16
        }
    }
    
    var sittingData: SittingData!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGraph(
            rawData: sittingData.dailyData,
            xFormatter: Formatter.DailyFormatter(),
            yFormatter: Formatter.MinutesFormatter()
        )
        updateUI(selectedType: .daily)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "座った時間"
    }

    func setUpGraph<T:AxisValueFormatter,U:AxisValueFormatter>(rawData: [SittingUnit], xFormatter: T, yFormatter: U){
        let floatData: [Float] = rawData.map{ $0.hours * 60 }
        let entries = floatData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemOrange]
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.xAxis.valueFormatter = xFormatter
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
        barChartView.rightAxis.valueFormatter = yFormatter
        
        barChartView.legend.enabled = false
        
        barChartView.animate(yAxisDuration: 1, easingOption: .easeOutBack)
    }
    
    func updateUI(selectedType: Term){
        switch selectedType {
        case .daily:
            self.hourLabel.text = String(Int(sittingData.dailySum * 60) / 60)
            self.minuteLabel.text = String(Int(sittingData.dailySum * 60) % 60)
            sumOrMeanLabel.text = "合計"
            setUpGraph(
                rawData: sittingData.dailyData,
                xFormatter: Formatter.DailyFormatter(),
                yFormatter: Formatter.MinutesFormatter()
            )
        case.weekly:
            self.hourLabel.text = String(Int(sittingData.weeklyMean * 60) / 60)
            self.minuteLabel.text = String(Int(sittingData.weeklyMean * 60) % 60)
            sumOrMeanLabel.text = "平均"
            setUpGraph(rawData: sittingData.weeklyData,
                       xFormatter: Formatter.WeeklyFormatter(),
                       yFormatter: Formatter.HoursFormatter())
        case .monthly:
            self.hourLabel.text = String(Int(sittingData.monthlyMean * 60) / 60)
            self.minuteLabel.text = String(Int(sittingData.weeklyMean * 60) % 60)
            sumOrMeanLabel.text = "平均"
            setUpGraph(rawData: sittingData.monthlyData,
                       xFormatter: Formatter.MonthlyFormatter(),
                       yFormatter: Formatter.HoursFormatter())
        }
    }
    
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        let type = Term(rawValue: sender.selectedSegmentIndex) ?? .daily
        updateUI(selectedType: type)
        print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
    }
}

