//
//  ForecastViewModel.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import Foundation
import Combine
import SwiftUI

class ForecastViewModel: ObservableObject {
    @Published var forecast: Forecast?
    @Published var forecastDict: [String: [Forecast.ForecastWeather]] = [:]
    @Published var iconCache = [String: Image]()

    private let networking = Networking.shared
    private var cancellables = Set<AnyCancellable>()

    func getForecast() {
        let location = Location(lat: UserDefaultsConfig.lat,
                                lon: UserDefaultsConfig.lon)

        networking.getForecast(location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("something went wrong: \(error)")
                }
            }, receiveValue: { value in
                self.forecast = value
                self.groupByDate(list: value.list)
            })
            .store(in: &cancellables)
    }

    func groupByDate(list: [Forecast.ForecastWeather]) {
        forecastDict = Dictionary(grouping: list) { key in
            FormatterFactory.dateFormatter.string(from: Date(timeIntervalSince1970: key.dt))
        }
    }

    func getIcon(_ iconCode: String) {
        guard !iconCache.keys.contains(where: { $0 == iconCode }) else {
            return
        }

        networking.getIcon(iconCode)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("something went wrong: \(error)")
                }
            }, receiveValue: { value in
                if let uiImage = UIImage(data: value) {
                    self.iconCache[iconCode] = Image(uiImage: uiImage)
                }
            })
            .store(in: &cancellables)
    }
}
