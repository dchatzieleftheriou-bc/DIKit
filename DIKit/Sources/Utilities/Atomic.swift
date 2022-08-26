// Copyright © Blockchain Luxembourg S.A. All rights reserved.

import Foundation

/// A wrapper for atomic access to a generic value.
final class Atomic<Value> {

    private let lock = UnfairLock()

    /// Atomic read access to the wrapped value.
    var value: Value {
        lock.withLock { _value }
    }

    // MARK: - Private Properties

    /// The wrapped value.
    private var _value: Value

    /// Creates an atomic wrapper.
    ///
    /// - Parameter value: A value.
    init(_ value: Value) {
        _value = value
    }

    // MARK: - Public Methods

    /// Atomically mutates the wrapped value.
    ///
    /// The `transform` closure should not perform any slow computation as it it blocks the current thread.
    ///
    /// - Parameters:
    ///   - transform: A transform closure, atomically mutating the wrapped value.
    ///   - current:   The current wrapped value, passed as an `inout` parameter to allow mutation.
    ///
    /// - Returns: The updated wrapped value.
    @discardableResult
    func mutate(_ transform: (_ current: inout Value) -> Void) -> Value {
        lock.withLock { () -> Value in
            transform(&_value)
            return _value
        }
    }

    /// Atomically mutates the wrapped value.
    ///
    /// The `transform` closure should not perform any slow computation as it it blocks the current thread.
    ///
    /// - Parameters:
    ///   - transform: A transform closure, atomically mutating the wrapped value.
    ///   - current:   The current wrapped value, passed as an `inout` parameter to allow mutation.
    ///
    /// - Returns: The return value of the `transform` closure.
    func mutateAndReturn<T>(_ transform: (_ current: inout Value) -> T) -> T {
        lock.withLock { transform(&_value) }
    }
}
