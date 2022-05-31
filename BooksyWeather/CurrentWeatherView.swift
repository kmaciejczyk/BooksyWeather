//
//  CurrentWeatherView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    @StateObject var viewModel = CurrentWeatherViewModel()

    var body: some View {
        ZStack {
            Color.orange.opacity(0.1).ignoresSafeArea()
        VStack {
            if let icon = viewModel.icon {
                icon.resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .background(Circle().fill(.orange.opacity(0.5)))
                    .padding(50)
            }
            if let weather = viewModel.currentWeather {
                Text(weather.name)
                    .font(.largeTitle)
                Text(weather.weather.first?.main ?? "")
                    .font(.title3)
                Text("\(weather.main.temp.rounded()) ˚C")
                    .font(.largeTitle)
                Spacer()
            }
        }
        .task {
            viewModel.getCurrentWeather()
        }
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
    }
}
