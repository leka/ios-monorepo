// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public protocol DatabaseOperations {
    func create<T: Codable>(data: T, in collection: DatabaseCollection) -> AnyPublisher<T, Error>
    func read<T: Decodable>(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<T, Error>
    func update<T: Encodable>(data: T, in collection: DatabaseCollection, documentID: String) -> AnyPublisher<Void, Error>
    func delete(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<Void, Error>

    // temporary - delete

    func fetchCompanyByOwnerUID(ownerUID: String) -> AnyPublisher<Company, Error>
}
