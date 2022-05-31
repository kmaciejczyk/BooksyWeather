//
//  BooksyWeatherApp.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

@main
struct BooksyWeatherApp: App {
    var networking = Networking()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networking)
        }
    }
}
