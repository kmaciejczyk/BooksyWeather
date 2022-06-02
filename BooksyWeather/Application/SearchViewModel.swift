//
//  SearchViewModel.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var results = [GeocodingDto]()
    @Published var inProgress = false

    private let networking = Networking.shared
    private var cancellables = Set<AnyCancellable>()

    func geocodeCity(city: String, state: String, country: String) {
        inProgress = true

        let payload = GeocodePayload(city: city,
                                     state: state,
                                     country: country)

        networking.geocodeLocation(payload: payload)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("something went wrong: \(error)")
                }
                self.inProgress = false
            }, receiveValue: { value in
                self.results = value
            })
            .store(in: &cancellables)
    }

    func saveCity(_ city: GeocodingDto) {
        UserDefaultsConfig.lat = city.lat
        UserDefaultsConfig.lon = city.lon
    }
}
