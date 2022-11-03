//
//  APIManager.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/22.
//

import Foundation

class APIManager {
    let udManager = UserDefaultsManager.shared
    func requestUrl(){
        let urlString:String = "https://api.jphacks2022.so298.net" + "/data/sitting/today" + "/" + String(udManager.getUserId()) + "/"
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
        requestDailySitting(sittingData: sittingData, completion: completion)
        
    }
    
    func requestDailySitting(sittingData: SittingData,  completion: @escaping (_ data :SittingData) -> Void){
        let urlString = "https://api.jphacks2022.so298.net/data/sitting/today/" + String(udManager.getUserId()) + "/"
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
                responseData.dailyData = try decoder.decode([SittingUnit].self, from: data)
                completion(sittingData)
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        })
        .resume()
    }
    
    func requestSittingSum(completion: @escaping (_ data :Float) -> Void){
        let urlString = "https://api.jphacks2022.so298.net/data/sitting/today/" + String(udManager.getUserId()) + "/"
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
                completion(responseData.map{$0.hours * 60}.reduce(0,+))
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        })
        .resume()
    }
   
}
