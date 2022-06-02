//
//  CurrentWeather.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct CurrentWeather: Codable {
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String?
        let sunrise: Double
        let sunset: Double
    }

    let coord: Location
    let weather: [Weather]
    let base: String
    let main: MainData
    let visibility: Int
    let wind: Wind
    let clouds: Cloud
    let dt: Double
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
