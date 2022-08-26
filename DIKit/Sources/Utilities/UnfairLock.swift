// https://developer.apple.com/documentation/uikit/uiimage/building_high-performance_lists_and_collection_views

import Foundation

final class UnfairLock {

    @usableFromInline let lock: UnsafeMutablePointer<os_unfair_lock>

    init() {
        lock = .allocate(capacity: 1)
        lock.initialize(to: os_unfair_lock())
    }

    deinit {
        lock.deallocate()
    }

    @inlinable
    @inline(__always)
    func withLock<Result>(body: () throws -> Result) rethrows -> Result {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        return try body()
    }

    @inlinable
    @inline(__always)
    func withLock(body: () -> Void) {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        body()
    }

    @inlinable
    @inline(__always)
    func assertOwner() {
        os_unfair_lock_assert_owner(lock)
    }

    @inlinable
    @inline(__always)
    func assertNotOwner() {
        os_unfair_lock_assert_not_owner(lock)
    }
}
