//
//  Networking.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 31/05/2022.
//

import Foundation
import Combine

class Networking: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var decoder = JSONDecoder()

    static var shared = Networking()

    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getCurrentWeather(location: Location) -> AnyPublisher<CurrentWeather, Error> {
        let url = ApiRoutes.currentLocationWeather(lat: location.lat, lon: location.lon).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: CurrentWeather.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func getForecast(location: Location) -> AnyPublisher<Forecast, Error> {
        let url = ApiRoutes.forecastWeather(location: location).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: Forecast.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func getIcon(_ iconCode: String) -> AnyPublisher<Data, URLError> {
        let url = ApiRoutes.icon(iconCode: iconCode).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .eraseToAnyPublisher()
    }

    func geocodeLocation(payload: GeocodePayload) -> AnyPublisher<[GeocodingDto], Error> {
        let url = ApiRoutes.geocodeLocation(payload: payload).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: [GeocodingDto].self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func getAirPolution(location: Location) -> AnyPublisher<AirPollution, Error> {
        let url = ApiRoutes.airpolution(location: location).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: AirPollution.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
