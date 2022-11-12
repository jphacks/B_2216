//
//  Formatter.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/11/12.
//

import Foundation
import Charts

class Formatter {
    public class DailyFormatter: NSObject, AxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return String(Int(value)) + ":00"
        }
    }

    public class WeeklyFormatter: NSObject, AxisValueFormatter{
        let dayNames: [String]! = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri","Sat"]
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return dayNames[Int(value)]
        }
    }
    
    public class MonthlyFormatter: NSObject, AxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return String(Int(value)) + "日"
        }
    }
    
    public class MinutesFormatter: NSObject, AxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return String(Int(value)) + "分"
        }
    }
    
    public class KiloGramFormatter: NSObject, AxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return String(Int(value)) + "Kg"
        }
    }

}
