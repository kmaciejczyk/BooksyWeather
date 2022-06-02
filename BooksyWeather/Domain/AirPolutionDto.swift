//
//  AirPolutionDto.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct AirPolutionDto: Codable {
    let coord: Location
    let list: [AirPolution]
}
