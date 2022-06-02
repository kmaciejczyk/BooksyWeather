//
//  UserDefault.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import Combine
import Foundation

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
