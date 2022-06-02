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
                                            HStack {
                                                Image(systemName: "thermometer")
                                                Text("\(FormatterFactory.formatter.string(from: NSNumber(value: item.main.tempMin)) ?? "--") ˚C")
                                                    .font(.subheadline)
                                                Spacer()

                                                Text("\(FormatterFactory.formatter.string(from: NSNumber(value: item.main.temp)) ?? "--") ˚C")
                                                    .bold()
                                                Spacer()

                                                Text("\(FormatterFactory.formatter.string(from: NSNumber(value: item.main.tempMax)) ?? "--") ˚C")
                                                    .font(.subheadline)
                                            }
                                            HStack {
                                                Image(systemName: "gauge")
                                                Text("\(item.main.pressure) hPa")
                                                Spacer()
                                                Image(systemName: "humidity.fill")
                                                Text("\(item.main.humidity) %")
                                            }
                                            HStack {
                                                Image(systemName: "wind")
                                                Text("\(FormatterFactory.twoDigitFormatter.string(from: NSNumber(value: item.wind.speed)) ?? "--") m/s")
                                                if let gust = item.wind.gust, gust != item.wind.speed {
                                                    Spacer()

                                                    Image(systemName: "tornado")
                                                    Text("\(FormatterFactory.twoDigitFormatter.string(from: NSNumber(value: gust)) ?? "--") m/s")
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

    func leftColumn(_ item: ForecastWeatherDto) -> some View {
        VStack {
            Text(FormatterFactory.dateTimeFormatter.string(from: Date(timeIntervalSince1970: item.dt)))
                .bold()

            Spacer()
            Text(item.weather.first?.main ?? "")
                .font(.subheadline)
        }
        .background(
            Group {
                if let icon = viewModel.cache[item.weather.first?.icon ?? ""] {
                    icon.resizable()
                        .scaledToFit()
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

    func bgColor(for item: ForecastWeatherDto) -> Color {
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
