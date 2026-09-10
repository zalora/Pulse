// The MIT License (MIT)
//
// Copyright (c) 2020-2026 Alexander Grebenyuk (github.com/kean).

import Foundation

package struct ConsoleListPredicateOptions: @unchecked Sendable {
    package var filters = ConsoleFilters()
    package var sessions: Set<UUID> = []
    package var isOnlyErrors = false
    package var predicate: NSPredicate?

    /// Narrows the list without touching the reader's own filters, so leaving
    /// a custom mode restores exactly what was showing before.
    ///
    /// - warning: Evaluated against `NetworkTaskEntity` and applied in
    /// ``ConsoleMode/network`` only. Anything set here must not be handed to a
    /// `LoggerMessageEntity` fetch.
    package var focus: NSPredicate?

    package init() {}
}
