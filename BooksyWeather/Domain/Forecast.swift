//
//  Forecast.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct Forecast: Codable {
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Location
        let country: String
        let population: Int
        let timezone: Int
        let sunset: Double
        let sunrise: Double
    }

    struct ForecastWeather: Codable, Identifiable {
        var id: Double { dt }

        let weather: [Weather]
        let main: MainData
        let visibility: Int
        let wind: Wind
        let clouds: Cloud
        let dt: Double
    }

    let cnt: Int
    let list: [ForecastWeather]
    let city: City
}
