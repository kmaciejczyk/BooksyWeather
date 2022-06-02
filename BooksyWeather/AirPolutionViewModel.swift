//
//  AirPolutionViewModel.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Combine
import Foundation

class AirPolutionViewModel: ObservableObject {
    @Published var airPolution: AirPolution?
    
    private let networking = Networking()
    private var cancellables = Set<AnyCancellable>()

    func getAirPolution() {
        let location = Location(lat: UserDefaultsConfig.lat,
                                lon: UserDefaultsConfig.lon)

        networking.getAirPolution(location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("something went wrong: \(error)")
                }
            }, receiveValue: { value in
                self.airPolution = value.list.first
            })
            .store(in: &cancellables)
    }
}

