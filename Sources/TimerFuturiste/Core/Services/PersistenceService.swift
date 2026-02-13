import Foundation

protocol PersistenceServicing {
    func saveTimer(configuredDuration: TimeInterval, endDate: Date?, isRunning: Bool)
    func loadTimer() -> (configuredDuration: TimeInterval, endDate: Date, isRunning: Bool)?
    func clearTimer()
}

final class PersistenceService: PersistenceServicing {
    private enum Keys {
        static let configuredDuration = "timer.configuredDuration"
        static let endDate = "timer.endDate"
        static let isRunning = "timer.isRunning"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func saveTimer(configuredDuration: TimeInterval, endDate: Date?, isRunning: Bool) {
        defaults.set(configuredDuration, forKey: Keys.configuredDuration)
        defaults.set(endDate, forKey: Keys.endDate)
        defaults.set(isRunning, forKey: Keys.isRunning)
    }

    func loadTimer() -> (configuredDuration: TimeInterval, endDate: Date, isRunning: Bool)? {
        guard
            let endDate = defaults.object(forKey: Keys.endDate) as? Date
        else {
            return nil
        }
        let configuredDuration = defaults.double(forKey: Keys.configuredDuration)
        let isRunning = defaults.bool(forKey: Keys.isRunning)
        return (configuredDuration, endDate, isRunning)
    }

    func clearTimer() {
        defaults.removeObject(forKey: Keys.configuredDuration)
        defaults.removeObject(forKey: Keys.endDate)
        defaults.removeObject(forKey: Keys.isRunning)
    }
}

