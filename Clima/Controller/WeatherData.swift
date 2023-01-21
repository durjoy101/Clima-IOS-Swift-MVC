//
//  WeatherData.swift
//  Clima
//
//  Created by Samar Mitra on 27/11/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
}
struct Main: Codable {
    var temp: Double
}
struct Weather: Codable {
    var id: Int
    var description: String
}
