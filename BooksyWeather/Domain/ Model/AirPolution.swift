//
//  AirPolution.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct AirPolution: Codable {
    let coord: Location
    let list: [AirPolutionData]
}
