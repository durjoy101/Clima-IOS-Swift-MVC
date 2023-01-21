//
//  WeatherManager.swift
//  Clima
//
//  Created by Samar Mitra on 26/11/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol weatherManagerDelegate {
    func updateWeather (weather: WeatherModel)
    func failError (error: Error)
    }


struct WeatherManager {
    let weatherURl = "https://api.openweathermap.org/data/2.5/weather?&appid=3b9eaa944faac784655b03bf5ee94505&units=metric"
    
    var delegate: weatherManagerDelegate?
    
    func fetchWeather (cityName: String){
        let urlString = "\(weatherURl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.failError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJson(weatherData: safeData) {
                        delegate?.updateWeather(weather: weather)
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        }catch{
            delegate?.failError(error: error)
            return nil
        }
    }
    
    
    
}
