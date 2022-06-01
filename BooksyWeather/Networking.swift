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

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getCurrentWeather(location: Location) -> AnyPublisher<CurrentWeatherDto, Error> {
//        Future<CurrentWeatherDto, Never> { promise in
            let url = ApiRoutes.currentLocationWeather(lat: location.lat, lon: location.lon).url

            return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
                .handleEvents(receiveOutput: { output in
                    print(String(data: output.data, encoding: .utf8))
                }, receiveCancel: {
                    print("Cancelled")
                })

                .map(\.data)
                .decode(type: CurrentWeatherDto.self, decoder: decoder)
                .eraseToAnyPublisher()
//        }
    }

    func getForecast(location: Location) -> AnyPublisher<ForecastDto, Error> {
        //        Future<CurrentWeatherDto, Never> { promise in
        let url = ApiRoutes.forecastWeather(location: location).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .handleEvents(receiveOutput: { output in
                print(String(data: output.data, encoding: .utf8))
            }, receiveCancel: {
                print("Cancelled")
            })

            .map(\.data)
            .decode(type: ForecastDto.self, decoder: decoder)
            .eraseToAnyPublisher()
        //        }
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
}


struct Location: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainData: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

struct Cloud: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Double
    let sunset: Double
}

struct CurrentWeatherDto: Codable {
    let coord: Location
    let weather: [Weather]
    let base: String
    let main: MainData
    let visibility: Int
    let wind: Wind
    let clouds: Cloud
    let dt: Double
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct GeocodingDto: Codable, Identifiable {
    var id: String { "\(lat)#\(lon)"}
    
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}

struct ForecastWeatherDto: Codable, Identifiable {
    var id: Double { dt }
    
    let weather: [Weather]
    let main: MainData
    let visibility: Int
    let wind: Wind
    let clouds: Cloud
    let dt: Double
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Location
    let country: String
    let population: Int
    let timezone: Int
    let sunset: Double
    let sunrise: Double
}

struct ForecastDto: Codable {
    let cnt: Int
    let list: [ForecastWeatherDto]
    let city: City
}
