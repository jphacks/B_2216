//
//  WeightData.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/11/03.
//

import Foundation


struct WeightData : Codable {
    var dailyData: [WeightUnit] = [] {
        didSet {
            dailyMean = 0
            for singleData in dailyData {
                dailyMean += singleData.value / Float(dailyData.count)
            }
        }
    }
    var weeklyData: [WeightUnit] = [] {
        didSet {
            weeklyMean = 0
            for singleData in weeklyData {
                weeklyMean += singleData.value / Float(weeklyData.count)
            }
        }
    }
    var monthlyData: [WeightUnit] = [] {
        didSet {
            monthlyMean = 0
            for singleData in monthlyData {
                monthlyMean += singleData.value / Float(monthlyData.count)
            }
        }
    }
    var dailyMean: Float = 0
    var weeklyMean: Float = 0
    var monthlyMean: Float = 0
    
    func getAllData(completion: @escaping (_ data :WeightData) -> Void) {
        let apiManager = APIManager()
        apiManager.requestWeight(weightData: self, completion: completion)
    }
}
