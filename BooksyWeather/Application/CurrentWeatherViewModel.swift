//
//  CurrentWeatherViewModel.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import Foundation
import Combine
import SwiftUI

class CurrentWeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var icon: Image?

    private let networking = Networking.shared
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func getCurrentWeather() {
        let location = Location(lat: UserDefaultsConfig.lat,
                                lon: UserDefaultsConfig.lon)

        networking.getCurrentWeather(location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("something went wrong: \(error)")
                }
            }, receiveValue: { value in
                self.currentWeather = value
                self.getIcon(value.weather.first?.icon ?? "")
                
                print(value)
                //                promise(.success(value))
            })
            .store(in: &cancellables)
    }

    func getIcon(_ iconCode: String) {
        networking.getIcon(iconCode)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("something went wrong: \(error)")
                }
            }, receiveValue: { value in
                if let uiImage = UIImage(data: value) {
                    self.icon = Image(uiImage: uiImage)
                }
            })
            .store(in: &cancellables)
    }
}
