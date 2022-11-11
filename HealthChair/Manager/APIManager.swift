//
//  APIManager.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/22.
//

import Foundation

class APIManager {
    let udManager = UserDefaultsManager.shared
    
    let baseUrl:String = "https://api.jphacks2022.so298.net/data"
    
    var userId: String {
        // String(udManager.getUserId())
        "7"
    }
    
    enum RequestType: String {
        case daily = "/today/"
        case weekly = "/week/"
        case monthly = "/month/"
    }
    
    func requestUrl(){
        let urlString:String = baseUrl + "/data/sitting/today" + "/" + userId + "/"
        print("post url: ", urlString)
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            print("json got")
            let decoder = JSONDecoder()
            do {
                let responseData: [SittingUnit] = try decoder.decode([SittingUnit].self, from: data)
                print(responseData.map{$0.hours})
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        })
        .resume()
    }
    
    func requestSitting(sittingData: SittingData,  completion: @escaping (_ data :SittingData) -> Void) {
        requestSingleSitting(sittingData: sittingData, type: .daily, completion: completion)
//        requestSingleSitting(sittingData: sittingData, type: .weekly, completion: completion)
//        requestSingleSitting(sittingData: sittingData, type: .monthly, completion: completion)
    }
    
    func requestWeight(weightData: WeightData,  completion: @escaping (_ data :WeightData) -> Void) {
        requestSingleWeight(weightData: weightData, type: .daily, completion: completion)
    }
    
    func requestSingleSitting(sittingData: SittingData, type: RequestType,  completion: @escaping (_ data :SittingData) -> Void){
        let urlString = baseUrl + "/sitting" + type.rawValue + userId + "/"
        print("post url: ", urlString)
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            print("json got")
            let decoder = JSONDecoder()
            do {
                var responseData = sittingData
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
                completion(responseData)
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        })
        .resume()
    }
    
    func requestSingleWeight(weightData: WeightData, type: RequestType,  completion: @escaping (_ data : WeightData) -> Void){
        let urlString = baseUrl + "/weight" + type.rawValue + userId + "/"
        print("post url: ", urlString)
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            print("json got")
            let decoder = JSONDecoder()
            do {
                var responseData = weightData
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
                completion(responseData)
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        })
        .resume()
    }
}
