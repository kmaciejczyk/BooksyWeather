//
//  ApiRoutes.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import Foundation

enum ApiRoutes {
    case currentLocationWeather(lat: Double, lon: Double)
    case geocodeLocation
    case forecastWeather
    case icon(iconCode: String)
//    case //airpolution
//    case //solarradiation

    var url: String {
        switch self {
        case let .currentLocationWeather(lat, lon):
            return AppConfig.apiUrl
                + "weather?lat=\(lat)&lon=\(lon)"
                + "&appid=\(AppConfig.apiKey)"
                + "&units=\(AppConfig.units)"
                + "&lang=\(AppConfig.language)"
        case .geocodeLocation:
            return ""
        case .forecastWeather:
            return ""
        case let .icon(iconCode):
            return AppConfig.iconUrl + iconCode + "@2x.png"
        }
    }
}
