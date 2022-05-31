//
//  ApiRoutes.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import Foundation

enum ApiRoutes {
    case currentLocationWeather(lat: Double, lon: Double)
    case geocodeLocation(payload: GeocodePayload)
    case forecastWeather
    case icon(iconCode: String)
//    case //airpolution
//    case //solarradiation

    var url: String {
        switch self {
        case let .currentLocationWeather(lat, lon):
            return AppConfig.apiUrl
                + "data/2.5/weather?lat=\(lat)&lon=\(lon)"
                + "&appid=\(AppConfig.apiKey)"
                + "&units=\(AppConfig.units)"
                + "&lang=\(AppConfig.language)"
        case let .geocodeLocation(payload):
            var query = payload.city
            if !payload.state.isEmpty {
                query = query + ",\(payload.state)"
            }
            if !payload.country.isEmpty {
                query = query + ",\(payload.country)"
            }
            return AppConfig.apiUrl
                + "geo/1.0/direct?q="
                + query
                + "&limit=10"
                + "&appid=\(AppConfig.apiKey)"
        case .forecastWeather:
            return ""
        case let .icon(iconCode):
            return AppConfig.iconUrl + iconCode + "@2x.png"
        }
    }
}
