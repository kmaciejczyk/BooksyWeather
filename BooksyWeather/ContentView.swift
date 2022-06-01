//
//  ContentView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = Tab.forecast
    @State private var exportedColor = Color.orange
    @State private var showWelcomeView = false
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
        .fullScreenCover(isPresented: $showWelcomeView) {
            WelcomeView()
//                .ignoresSafeArea()
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
