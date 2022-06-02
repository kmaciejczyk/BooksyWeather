//
//  AirPollution.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct AirPollution: Codable {
    let coord: Location
    let list: [AirPollutionData]
}
