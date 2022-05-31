//
//  ContentView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = Tab.currentWeather
    @State var exportedColor = Color.orange

    var body: some View {
        TabView(selection: $selectedTab) {
            CurrentWeatherView(tab: $selectedTab, exportedColor: $exportedColor)
                .tabItem {
                    Label("Current", systemImage: "sun.max.fill")
                }
                .tag(Tab.currentWeather)
            ForecastView(tab: $selectedTab, exportedColor: $exportedColor)
                .tabItem {
                    Label("Forecast", systemImage: "calendar")
                }
                .tag(Tab.forecast)
            SearchView(tab: $selectedTab, exportedColor: $exportedColor)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.cityChoice)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Tab {
    case currentWeather, forecast, cityChoice
}
