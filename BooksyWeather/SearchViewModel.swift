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

    private let networking = Networking()
    private var cancellables = Set<AnyCancellable>()

    func geocodeCity(city: String, state: String, country: String) {
        inProgress = true

        let payload = GeocodePayload(city: city, state: state, country: country)

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

struct GeocodePayload {
    let city, state, country: String
}

enum PreferenceKey: String, CaseIterable {
    case lat
    case lon
}

enum UserDefaultsConfig {
    @UserDefault(PreferenceKey.lat.rawValue, defaultValue: 0.0)
    static var lat: Double

    @UserDefault(PreferenceKey.lon.rawValue, defaultValue: 0.0)
    static var lon: Double
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    private let publisher: CurrentValueSubject<T, Never>

    init(_ key: String, defaultValue: T) {
        UserDefaults.standard.register(defaults: [key: NSData()])
        self.key = key
        self.defaultValue = defaultValue
        let currentValue = UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        publisher = CurrentValueSubject(currentValue)
    }

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }

        set {
            publisher.value = newValue

            if let optional = newValue as? AnyOptional, optional.isNil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }

    var projectedValue: AnyPublisher<T, Never> {
        publisher.eraseToAnyPublisher()
    }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    init(_ key: String, storage _: UserDefaults = .standard) {
        self.init(key, defaultValue: nil)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
