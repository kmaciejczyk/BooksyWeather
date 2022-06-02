//
//  AirPolutionView.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import SwiftUI

struct AirPolutionView: View {
    @StateObject var viewModel = AirPolutionViewModel()

    @Binding var tab: Tab
    @Binding var exportedColor: Color

    init(tab: Binding<Tab>, exportedColor: Binding<Color>) {
        _tab = tab
        _exportedColor = exportedColor
    }

    var columns = [
        GridItem(),
        GridItem(),
    ]

    var body: some View {
        NavigationView {
            ZStack {
                exportedColor.opacity(0.1).ignoresSafeArea()

                if let airPolution = viewModel.airPolution {
                    VStack {
                        aqi(airPolution: airPolution)
                        ScrollView {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                                gridElements(airPolution: airPolution)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Air Polution")
        }
        .onAppear {
            viewModel.getAirPolution()
        }
    }

    func aqi(airPolution: AirPolution) -> some View {
        VStack {
            Group {
                switch airPolution.main.aqi {
                case 1:
                    Image(systemName: "aqi.low")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                case 2:
                    Image(systemName: "aqi.medium")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                case 3:
                    Image(systemName: "aqi.medium")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                case 4:
                    Image(systemName: "aqi.high")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                case 5:
                    Image(systemName: "aqi.high")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                default:
                    Image(uiImage: UIImage())
                }
            }
            .frame(width: 60, height: 60, alignment: .center)
            .padding(20)
            .background(Circle().fill(Color.white))
            .padding(.bottom, 10)
        }
    }

    func gridElements(airPolution: AirPolution) -> some View {
        Group {
            particleDensity(title: "AQI", particleValue: airPolution.main.aqi)
            particleDensity(title: "CO", particleValue: airPolution.components.co)
            particleDensity(title: "PM 2.5", particleValue: airPolution.components.pm25)
            particleDensity(title: "PM 10", particleValue: airPolution.components.pm10)
            particleDensity(title: "NO", particleValue: airPolution.components.no)
            particleDensity(title: "NO2", particleValue: airPolution.components.no2)
            particleDensity(title: "O3", particleValue: airPolution.components.o3)
            particleDensity(title: "SO2", particleValue: airPolution.components.so2)
            particleDensity(title: "NH3", particleValue: airPolution.components.nh3)
        }
    }

    func particleDensity(title: String, particleValue: Double) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .bold()
                .font(.title2)

            Text("\(FormatterFactory.twoDigitFormatter.string(from: NSNumber(value: particleValue)) ?? "--") μg/m3")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(exportedColor.opacity(0.3)))
    }
}

struct AirPolutionView_Previews: PreviewProvider {
    static var previews: some View {
        AirPolutionView(tab: .constant(.airPolution), exportedColor: .constant(.orange))
    }
}
