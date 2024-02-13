// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAuth
import FirebaseFirestore

public class DatabaseOperations {
    // MARK: Lifecycle

    public init() {
        // Just to expose the init publicly
    }

    // MARK: Public

    public func create<T: AccountDocument>(data: T, in collection: DatabaseCollection) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document()

            var documentData = data
            documentData.rootOwnerUid = Auth.auth().currentUser?.uid ?? ""

            do {
                try docRef.setData(from: documentData) { error in
                    if let error {
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        promise(.success(documentData))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    public func read<T: AccountDocument>(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(documentID)
            docRef.getDocument { document, error in
                if let error {
                    promise(.failure(error))
                } else {
                    do {
                        let object = try document?.data(as: T.self)
                        if let object {
                            promise(.success(object))
                        } else {
                            promise(.failure(DatabaseError.documentNotFound))
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func readAll<T: AccountDocument>(from collection: DatabaseCollection) -> AnyPublisher<[T], Error> {
        Future<[T], Error> { promise in
            self.database.collection(collection.rawValue)
                .getDocuments { querySnapshot, error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        let objects = querySnapshot?.documents.compactMap { document -> T? in
                            try? document.data(as: T.self)
                        } ?? []
                        promise(.success(objects))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Private

    private let database = Firestore.firestore()
}
