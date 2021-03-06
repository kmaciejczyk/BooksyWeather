//
//  ForecastView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI
import SwiftDate

struct ForecastView: View {
    @StateObject var viewModel = ForecastViewModel()

    @Binding var tab: Tab
    @Binding var exportedColor: Color

    init(tab: Binding<Tab>, exportedColor: Binding<Color>) {
        _tab = tab
        _exportedColor = exportedColor
    }
    
    var body: some View {
        NavigationView {
            if let forecast = viewModel.forecast {
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(Array(viewModel.forecastDict.keys).sorted(), id: \.self) { key in
                                HStack {
                                    Text(forecast.city.name)
                                    Spacer()
                                    Text(key)
                                }
                                .padding(.horizontal)
                                .font(.title2)

                                ForEach(viewModel.forecastDict[key] ?? []) { item in
                                    HStack {
                                        leftColumn(item)

                                        VStack(alignment: .leading, spacing: 10) {
                                            temperatureRow(item)

                                            HStack {
                                                Image(systemName: "gauge")
                                                Text(formatMeasurement(value: item.main.pressure, unit: UnitPressure.hectopascals))
                                                Spacer()
                                                Image(systemName: "humidity.fill")
                                                Text(FormatterFactory.percentFormatter.string(from: NSNumber(value: item.main.humidity/100)) ?? "")
                                            }
                                            HStack {
                                                Image(systemName: "wind")
                                                Text(formatMeasurement(value: item.wind.speed, unit: UnitSpeed.metersPerSecond))
                                                if let gust = item.wind.gust, gust != item.wind.speed {
                                                    Spacer()

                                                    Image(systemName: "tornado")
                                                    Text(formatMeasurement(value: gust, unit: UnitSpeed.metersPerSecond))
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(bgColor(for: item).opacity(0.5)))
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("5 day forecast")
                .background(exportedColor.opacity(0.2).ignoresSafeArea())
            }
        }
        .onAppear {
            viewModel.getForecast()
        }
    }

    func leftColumn(_ item: Forecast.ForecastWeather) -> some View {
        VStack {
            Text(FormatterFactory.dateTimeFormatter.string(from: Date(timeIntervalSince1970: item.dt)))
                .bold()

            Spacer()
            Text(item.weather.first?.main ?? "")
                .font(.subheadline)
        }
        .background(
            Group {
                if let icon = viewModel.iconCache[item.weather.first?.icon ?? ""] {
                    icon.resizable()
                        .scaledToFit()
                        .frame(width: 70)
                }
            })
        .frame(width: 90)
        .padding(.trailing, 20)
        .onAppear {
            if let icon = item.weather.first?.icon {
                viewModel.getIcon(icon)
            }
        }
    }

    func formatMeasurement(value: Double, unit: Dimension) -> String {
        FormatterFactory.measurmentFormatter.string(from: Measurement(value: value, unit: unit))
    }

    func temperatureRow(_ item: Forecast.ForecastWeather) -> some View {
        HStack {
            Image(systemName: "thermometer")
            Text(formatMeasurement(value: item.main.tempMin, unit: UnitTemperature.celsius))
                .font(.subheadline)
            Spacer()

            Text(formatMeasurement(value: item.main.temp, unit: UnitTemperature.celsius))
                .bold()
            Spacer()

            Text(formatMeasurement(value: item.main.tempMax, unit: UnitTemperature.celsius))
                .font(.subheadline)
        }
    }

    func bgColor(for item: Forecast.ForecastWeather) -> Color {
        if let sunrise = viewModel.forecast?.city.sunrise,
           let sunset = viewModel.forecast?.city.sunset {
            if Date(timeIntervalSince1970: item.dt).hour >= Date(timeIntervalSince1970: sunrise).hour,
               Date(timeIntervalSince1970: item.dt).hour <= Date(timeIntervalSince1970: sunset).hour {
                return Color.orange
            } else {
                return Color.blue
            }
        }

        return Color.yellow
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(tab: .constant(.forecast), exportedColor: .constant(.orange))
    }
}
