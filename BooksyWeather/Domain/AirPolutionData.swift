//
//  AirPolutionData.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct AirPolutionData: Codable {
    struct Main: Codable {
        let aqi: Double
    }

    struct Particle: Codable {
        let co, no, no2, o3, so2, pm25, pm10, nh3: Double
    }

    let dt: Double
    let main: Main
    let components: Particle
}
