//
//  Comparator.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

final class Comparator<T> {
    private let model: T
    private var hasher = Hasher()

    /// Результирующий хэш
    var result: AnyHashable {
        hasher.finalize()
    }

    /// Инициализация
    /// - Parameter model: модель
    init(model: T) {
        self.model = model
        hasher.combine(String(describing: T.self))
    }

    /// Добавить проперти для сравнения
    /// - Returns: проперти
    public func property<Property: Hashable>(_ key: KeyPath<T, Property>) -> Self {
        hasher.combine(model[keyPath: key])
        return self
    }
}
