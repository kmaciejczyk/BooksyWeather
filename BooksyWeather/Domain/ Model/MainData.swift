//
//  MainData.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct MainData: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Double
    let humidity: Int
}
