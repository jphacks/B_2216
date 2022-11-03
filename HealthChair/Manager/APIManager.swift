//
//  APIManager.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/22.
//

import Foundation

class APIManager {
    let udManager = UserDefaultsManager.shared
    
    let baseUrl:String = "https://api.jphacks2022.so298.net"
    
    var userId: String {
        // String(udManager.getUserId())
        "7"
    }
    
    enum SittingType: String {
        case daily = "/data/sitting/today/"
        case weekly = "/data/sitting/weekly/"
        case monthly = "/data/sitting/monthly/"
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
        requestDailySitting(sittingData: sittingData, type: .daily, completion: completion)
    }
    
    func requestDailySitting(sittingData: SittingData, type: SittingType,  completion: @escaping (_ data :SittingData) -> Void){
        let urlString = baseUrl + type.rawValue + userId + "/"
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
}
