//
//  NetworkManager.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import Foundation

class NetworkManager {
    static let api = "https://api.nasa.gov/planetary/apod?api_key=VJ9PD8OHGI0sLmErkzfYOYMKIhC1YPdjHUIrTeKx"
    
    static func fetchData(url: String, completion: @escaping (APOD) -> () ) {
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
            guard err == nil else {
                print("er:::", err!)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(APOD.self, from: data)
                completion(jsonData)
            } catch {
                print("Error decoding JSON:", error)
            }
        }.resume()
    }
    
    private static func generateRandomDate() -> String {
        let startDate = Date(timeIntervalSince1970: 802572000) // June 20, 1995, in seconds
        let currentDate = Date()
        let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(currentDate.timeIntervalSince(startDate))))
        let randomDate = startDate.addingTimeInterval(randomTimeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: randomDate)
    }
    
    static func fetchRandomDate(completion: @escaping (APOD) -> () ) {
        let randomDate = generateRandomDate()
        let urlWithRandomDate = "\(api)&date=\(randomDate)"
        
        guard let url = URL(string: urlWithRandomDate) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard err == nil else {
                print("Error: ", err!)
                return
            }
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(APOD.self, from: data)
                completion(jsonData)
            } catch {
                print("Error decoding JSON: ", error)
            }
        }.resume()
    }
}
