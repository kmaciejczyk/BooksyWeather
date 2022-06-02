//
//  Wind.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double?
}
