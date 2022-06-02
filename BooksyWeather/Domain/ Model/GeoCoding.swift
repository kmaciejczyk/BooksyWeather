//
//  GeoCoding.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

struct GeocodingDto: Codable, Identifiable {
    var id: String { "\(lat)#\(lon)"}

    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
