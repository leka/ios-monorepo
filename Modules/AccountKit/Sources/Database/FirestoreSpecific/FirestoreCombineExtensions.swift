// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseFirestore

// MARK: - QuerySnapshotPublisher

public struct QuerySnapshotPublisher: Publisher {
    // MARK: Lifecycle

    init(query: Query) {
        self.query = query
    }

    // MARK: Public

    public typealias Output = QuerySnapshot
    public typealias Failure = Error

    public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = QuerySnapshotSubscription(subscriber: subscriber, query: query)
        subscriber.receive(subscription: subscription)
    }

    // MARK: Private

    private let query: Query
}

// MARK: - QuerySnapshotSubscription

private final class QuerySnapshotSubscription<S: Subscriber>: Subscription where S.Input == QuerySnapshot, S.Failure == Error {
    // MARK: Lifecycle

    init(subscriber: S, query: Query) {
        self.subscriber = subscriber
        self.listener = query.addSnapshotListener { querySnapshot, error in
            if let error {
                subscriber.receive(completion: .failure(error))
            } else if let querySnapshot {
                _ = subscriber.receive(querySnapshot)
            }
        }
    }

    // MARK: Internal

    func request(_: Subscribers.Demand) {
        // Firestore handles backpressure internally, so we don't need to do anything here.
    }

    func cancel() {
        self.listener?.remove()
        self.listener = nil
        self.subscriber = nil
    }

    // MARK: Private

    private var listener: ListenerRegistration?
    private var subscriber: S?
}
