//
//  MainNavigationView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct MainNavigationView: View {
    @State private var selectedTab = Tab.currentWeather
    @State private var exportedColor = Color.orange
    @State private var showWelcomeView: Bool

    init() {
        print(UserDefaultsConfig.showWelcomeView)
        _showWelcomeView = State(initialValue: UserDefaultsConfig.showWelcomeView)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CurrentWeatherView(tab: $selectedTab, exportedColor: $exportedColor)
                .tabItem {
                    Label("Current", systemImage: "sun.max.fill")
                }
                .tag(Tab.currentWeather)

            AirPolutionView(tab: $selectedTab, exportedColor: $exportedColor)
                .tabItem {
                    Label("Air Polution", systemImage: "aqi.medium")
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
        .fullScreenCover(isPresented: $showWelcomeView) {
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
