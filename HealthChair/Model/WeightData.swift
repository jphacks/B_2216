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
            var cnt = 0
            dailyMean = 0
            for singleData in dailyData {
                if singleData.value != 0 {
                    cnt += 1
                    dailyMean += singleData.value
                }
            }
            if cnt != 0{
                dailyMean /= Float(cnt)
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
    
    func getAllData() async throws -> WeightData {
        let apiManager = APIManager()
        return try await apiManager.requestWeight(weightData: self)
    }
}
