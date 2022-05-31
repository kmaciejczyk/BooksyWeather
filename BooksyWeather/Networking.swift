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

    func getIcon(_ iconCode: String) -> AnyPublisher<Data, URLError> {
        let url = ApiRoutes.icon(iconCode: iconCode).url

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
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
}

struct Cloud: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let message: Double?
    let country: String
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
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

/*
 {
 "coord": {
 "lon": -122.08,
 "lat": 37.39
 },
 "weather": [
 {
 "id": 800,
 "main": "Clear",
 "description": "clear sky",
 "icon": "01d"
 }
 ],
 "base": "stations",
 "main": {
 "temp": 282.55,
 "feels_like": 281.86,
 "temp_min": 280.37,
 "temp_max": 284.26,
 "pressure": 1023,
 "humidity": 100
 },
 "visibility": 10000,
 "wind": {
 "speed": 1.5,
 "deg": 350
 },
 "clouds": {
 "all": 1
 },
 "dt": 1560350645,
 "sys": {
 "type": 1,
 "id": 5122,
 "message": 0.0139,
 "country": "US",
 "sunrise": 1560343627,
 "sunset": 1560396563
 },
 "timezone": -25200,
 "id": 420006353,
 "name": "Mountain View",
 "cod": 200
 }
 */
