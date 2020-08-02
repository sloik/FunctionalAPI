
import Foundation

public struct Phantom<WitnessType, Wrapped> {
    let value: Wrapped

    init(value: Wrapped) {
        self.value = value
    }
}

public extension Phantom {

    @discardableResult
    func process<To>(_ transform: @escaping (Phantom<WitnessType, Wrapped>) -> Phantom<To, Wrapped>) -> Phantom<To, Wrapped> {
        transform(self)
    }
}
