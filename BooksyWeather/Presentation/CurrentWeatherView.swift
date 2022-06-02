//
//  CurrentWeatherView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    @StateObject var viewModel = CurrentWeatherViewModel()

    @Binding var tab: Tab
    @Binding var exportedColor: Color

    @State var degrees: Double = 0
    @State var offset: Double = 0

    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var color: Color {
        if let weather = viewModel.currentWeather {
            if Date() > Date(timeIntervalSince1970: weather.sys.sunrise)
                && Date() < Date(timeIntervalSince1970: weather.sys.sunset) {
                return .orange
            } else {
                return .blue
            }
        }
        return .gray
    }
    
    init(tab: Binding<Tab>, exportedColor: Binding<Color>) {
        _tab = tab
        _exportedColor = exportedColor
    }

    var body: some View {
        ZStack {
            color.opacity(0.1).ignoresSafeArea()

            VStack {
                weatherIcon

                if let weather = viewModel.currentWeather {
                    Text(FormatterFactory.measurmentFormatter.string(from: Measurement(value: weather.main.temp, unit: UnitTemperature.celsius)))
                        .font(Font.system(size: 50))

                    Text(weather.weather.first?.main ?? "")
                        .font(.title)
                        .padding(.bottom, 10)
                    Text(weather.name)
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .top) {
                        tempSection
                        windSection
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(color.opacity(0.3)))
                    .padding([.horizontal, .bottom])

                    HStack {
                        VStack(spacing: 4) {
                            measurementField(title: "Pressure",
                                             icon: "gauge",
                                             value: weather.main.pressure,
                                             unit: UnitPressure.hectopascals)

                            measurementField(title: "Visibility",
                                             icon: "eye.fill",
                                             value: weather.visibility,
                                             unit: UnitLength.meters)
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 4) {
                            dateTimeField(title: "Sunrise",
                                          icon: "sunrise.fill",
                                          color: .yellow,
                                          timestamp: weather.sys.sunrise)

                            dateTimeField(title: "Sunset",
                                          icon: "sunset.fill",
                                          color: .red,
                                          timestamp: weather.sys.sunset)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(color.opacity(0.3)))
                    .padding([.horizontal, .bottom])

                    Spacer()
                }
            }
            .task {
                viewModel.getCurrentWeather()
            }
            .onChange(of: color) { color in
                exportedColor = color
            }
        }
    }

    var weatherIcon: some View {
        Group {
            if let icon = viewModel.icon {
                icon.resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .offset(x: offset)
                    .onReceive(timer) { t in
                        if offset <= 0 {
                            offset = offset + 50
                        } else {
                            offset = offset - 100
                        }
                    }
                    .animation(.interpolatingSpring(stiffness: 120, damping: 15).speed(0.2), value: offset)
                    .mask(Circle())
                    .background(Circle().fill(color.opacity(0.5)))
                    .padding(10)
            }
        }
    }

    func measurementField(title: String, icon: String, value: Double, unit: Dimension) -> some View {
        VStack {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            Text(FormatterFactory.measurmentFormatter.string(from: Measurement(value: value, unit: unit)))
                .bold()
        }
    }

    func dateTimeField(title: String, icon: String, color: Color, timestamp: Double) -> some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
            }
            .font(.subheadline)

            Text(FormatterFactory.dateTimeFormatter.string(from: Date(timeIntervalSince1970: timestamp)))
                .bold()
                .padding(.bottom, 2)
        }
    }

    var tempSection: some View {
        VStack(spacing: 4) {
            if let weather = viewModel.currentWeather {
                measurementField(title: "Feels like",
                                 icon: "thermometer",
                                 value: weather.main.feelsLike,
                                 unit: UnitTemperature.celsius)

                if weather.main.tempMin != weather.main.temp {
                    measurementField(title: "Minimal",
                                     icon: "thermometer",
                                     value: weather.main.tempMin,
                                     unit: UnitTemperature.celsius)
                }

                if weather.main.tempMax != weather.main.temp {
                    measurementField(title: "Maximal",
                                     icon: "thermometer",
                                     value: weather.main.tempMax,
                                     unit: UnitTemperature.celsius)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    var windSection: some View {
        VStack(spacing: 4) {
            if let weather = viewModel.currentWeather {
                measurementField(title: "Wind speed",
                                 icon: "wind",
                                 value: weather.wind.speed,
                                 unit: UnitSpeed.metersPerSecond)
                    .padding(.bottom, 2)

                Image(systemName: "line.diagonal.arrow")
                    .resizable()
                    .rotationEffect(Angle(degrees: -45))
                    .rotationEffect(Angle(degrees: degrees))
                    .animation(.interpolatingSpring(stiffness: 170, damping: 5), value: degrees)
                    .padding()
                    .background(Image(systemName: "circle.dotted").resizable().scaledToFit())
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 2)
                    .onReceive(viewModel.$currentWeather) { cw in
                        degrees = cw?.wind.deg ?? 0
                    }
                    .onReceive(timer) { t in
                        if degrees > weather.wind.deg {
                            degrees = degrees - 6
                        } else {
                            degrees = degrees + 6
                        }
                    }

                if let gust = weather.wind.gust {
                    measurementField(title: "Wind gust",
                                     icon: "tornado",
                                     value: gust,
                                     unit: UnitSpeed.metersPerSecond)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    func formattedValue(_ value: Double) -> String {
        FormatterFactory.formatter.string(from: NSNumber(value: value)) ?? "--"
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(tab: .constant(.currentWeather), exportedColor: .constant(.orange))
    }
}
