//
//  SittingData.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/16.
//

import Foundation

struct SittingData : Codable {
    var dailyData: [SittingUnit] = [] {
        didSet {
            dailySum = 0
            for singleData in dailyData {
                dailySum += singleData.hours
            }
        }
    }
    var weeklyData: [SittingUnit] = [] {
        didSet {
            weeklyMean = 0
            for singleData in weeklyData {
                weeklyMean += singleData.hours / Float(weeklyData.count)
            }
        }
    }
    var monthlyData: [SittingUnit] = [] {
        didSet {
            monthlyMean = 0
            for singleData in monthlyData {
                monthlyMean += singleData.hours / Float(monthlyData.count)
            }
        }
    }
    var dailySum: Float = 0
    var weeklyMean: Float = 0
    var monthlyMean: Float = 0
    
    func getAllData(completion: @escaping (_ data :SittingData) -> Void) {
        var apiManager = APIManager()
        apiManager.requestSitting(sittingData: self, completion: completion)
    }
}
