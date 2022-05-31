//
//  ContentView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CurrentWeatherView()
                .tabItem {
                    Label("Current", systemImage: "sun.max.fill")
                }
            ForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "calendar")
                }
            CityChoiceView()
                .tabItem {
                    Label("City", systemImage: "building.2.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
