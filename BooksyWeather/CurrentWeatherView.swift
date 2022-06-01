//
//  CurrentWeatherView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import SwiftUI

enum FormatterFactory {
    static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    static var twoDigitFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

struct CurrentWeatherView: View {
    @StateObject var viewModel = CurrentWeatherViewModel()

    @State var degrees: Double = 0
    @State var offset: Double = 0



    func formattedValue(_ value: Double) -> String {
        FormatterFactory.formatter.string(from: NSNumber(value: value)) ?? "--"
    }

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

    @Binding var tab: Tab
    @Binding var exportedColor: Color
    
    init(tab: Binding<Tab>, exportedColor: Binding<Color>) {
        _tab = tab
        _exportedColor = exportedColor
    }

    var body: some View {
        ZStack {
            color.opacity(0.1).ignoresSafeArea()

            VStack {
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
                if let weather = viewModel.currentWeather {
                    Text("\(formattedValue(weather.main.temp)) ˚C")
                        .font(Font.system(size: 50))

                    Text(weather.weather.first?.main ?? "")
                        .font(.title)
                        .padding(.bottom, 10)
                    Text(weather.name)
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                    HStack(alignment: .top) {

                        VStack(spacing: 4) {
                            VStack {
                            HStack {
                                Image(systemName: "thermometer")
                                Text("Feels like")
                            }
                            Text("\(formattedValue(weather.main.feelsLike)) ˚C")
                                .bold()
                            }
                            .font(weather.main.tempMin == weather.main.temp && weather.main.tempMax == weather.main.temp ? .title : .subheadline)
                            if weather.main.tempMin != weather.main.temp {
                                HStack {
                                    Image(systemName: "thermometer")
                                    Text("Minimal")
                                }
                                .font(.subheadline)
                                Text("\(formattedValue(weather.main.tempMin)) ˚C")
                                    .bold()
                                    .padding(.bottom, 2)
                            }
                            if weather.main.tempMax != weather.main.temp {
                                HStack {
                                    Image(systemName: "thermometer")
                                    Text("Maximal")
                                }
                                Text("\(formattedValue(weather.main.tempMax)) ˚C")
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 4) {
                            HStack {
                                Image(systemName: "wind")
                                Text("Wind speed")
                            }.font(.subheadline)

                            Text("\(FormatterFactory.twoDigitFormatter.string(from: NSNumber(value: weather.wind.speed)) ?? "--") m/s")
                                .bold()
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
                                HStack {
                                    Image(systemName: "wind")
                                    Text("Wind gust")
                                }
                                .font(.subheadline)

                                Text("\(FormatterFactory.twoDigitFormatter.string(from: NSNumber(value: gust)) ?? "--") m/s")
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(color.opacity(0.3)))
                    .padding([.horizontal, .bottom])

                    HStack {
                        VStack(spacing: 4) {
                            HStack {
                                Image(systemName: "gauge")
                                Text("Pressure")
                            }
                            .font(.subheadline)
                            Text("\(weather.main.pressure) hPa")
                                .bold()
                                .padding(.bottom, 2)
                            HStack {
                                Image(systemName: "eye.fill")
                                Text("Visibility")
                            }
                            .font(.subheadline)
                            Text("\(weather.visibility) m")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 4) {
                            HStack {
                                Image(systemName: "sunrise.fill")
                                    .foregroundColor(.yellow)
                                Text("Sunrise")
                            }
                            .font(.subheadline)


                            Text(FormatterFactory.dateTimeFormatter.string(from: Date(timeIntervalSince1970: weather.sys.sunrise)))
                                .bold()
                                .padding(.bottom, 2)
                            HStack {
                                Image(systemName: "sunset.fill")
                                    .foregroundColor(.red)

                                Text("Sunset")
                            }
                            .font(.subheadline)
                            Text(FormatterFactory.dateTimeFormatter.string(from: Date(timeIntervalSince1970: weather.sys.sunset)))
                                .bold()

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
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(tab: .constant(.currentWeather), exportedColor: .constant(.orange))
    }
}
