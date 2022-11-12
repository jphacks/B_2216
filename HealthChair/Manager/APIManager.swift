//
//  APIManager.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/22.
//

import Foundation

class APIManager {
    let udManager = UserDefaultsManager.shared
    
    let baseUrl:String = Endpoint.MOCK_URL
    
    var userId: String {
        // String(udManager.getUserId())
        "7"
    }
    
    enum RequestType: String {
        case daily = "/today/"
        case weekly = "/week/"
        case monthly = "/month/"
    }
    
    func requestSitting(sittingData: SittingData) async throws -> SittingData {
        var response = sittingData
        response = try await self.requestSingleSitting(sittingData: response, type: .daily)
        response = try await self.requestSingleSitting(sittingData: response, type: .weekly)
        response = try await self.requestSingleSitting(sittingData: response, type: .monthly)
        return response
    }
    
    func requestWeight(weightData: WeightData) async throws -> WeightData {
        var response = weightData
        response = try await self.requestSingleWeight(weightData: response, type: .daily)
        response = try await self.requestSingleWeight(weightData: response, type: .weekly)
        response = try await self.requestSingleWeight(weightData: response, type: .monthly)
        return response
    }
    
    func requestSingleSitting(sittingData: SittingData, type: RequestType) async throws -> SittingData {
        let urlString = baseUrl + "/sitting" + type.rawValue + userId + "/"
        print("post url: ", urlString)
        let url = URL(string: urlString)!
        let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
        print("json got")
        let decoder = JSONDecoder()
        var responseData = sittingData
        do {
            switch type {
            case .daily:
                responseData.dailyData = try decoder.decode([SittingUnit].self, from: data)
                break
            case .weekly:
                responseData.weeklyData = try decoder.decode([SittingUnit].self, from: data)
                break
            case .monthly:
                responseData.monthlyData = try decoder.decode([SittingUnit].self, from: data)
                break
            }
        } catch let parseError {
            print("JSON Error \(parseError.localizedDescription)")
        }
        return responseData
    }
    
    func requestSingleWeight(weightData: WeightData, type: RequestType) async throws -> WeightData {
        let urlString = baseUrl + "/weight" + type.rawValue + userId + "/"
        print("post url: ", urlString)
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
        print("json got")
        let decoder = JSONDecoder()
        var responseData = weightData
        do {
            switch type {
            case .daily:
                responseData.dailyData = try decoder.decode([WeightUnit].self, from: data)
                break
            case .weekly:
                responseData.weeklyData = try decoder.decode([WeightUnit].self, from: data)
                break
            case .monthly:
                responseData.monthlyData = try decoder.decode([WeightUnit].self, from: data)
                break
            }
        } catch let parseError {
            print("JSON Error \(parseError.localizedDescription)")
        }
        return responseData
    }
}
