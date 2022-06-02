//
//  UserDefaultsConfig.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Foundation

enum UserDefaultsConfig {
    @UserDefault(PreferenceKey.lat.rawValue, defaultValue: 0.0)
    static var lat: Double

    @UserDefault(PreferenceKey.lon.rawValue, defaultValue: 0.0)
    static var lon: Double

    @UserDefault(PreferenceKey.showWelcomeView.rawValue, defaultValue: true)
    static var showWelcomeView: Bool
}
