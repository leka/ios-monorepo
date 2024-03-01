// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public class DatabaseOperations {
    // MARK: Lifecycle

    public init() {
        // Just to expose the init publicly
    }

    // MARK: Public

    public static let shared = DatabaseOperations()

    public func create(data: some AccountDocument, in collection: DatabaseCollection) -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document()
            var documentData = data
            documentData.rootOwnerUid = Auth.auth().currentUser?.uid ?? ""
            documentData.id = docRef.documentID

            do {
                try docRef.setData(from: documentData) { error in
                    if let error {
                        log.error("\(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Document \(docRef.documentID) created successfully in \(collection). 🎉")
                        promise(.success(docRef.documentID))
                    }
                }
            } catch {
                log.error("\(error.localizedDescription)")
                promise(.failure(DatabaseError.encodeError))
            }
        }
        .eraseToAnyPublisher()
    }

    public func read<T: AccountDocument>(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(documentID)
            docRef.getDocument { document, error in
                if let error {
                    log.error("\(error.localizedDescription)")
                    promise(.failure(error))
                } else {
                    do {
                        let object = try document?.data(as: T.self)
                        if let object {
                            log.info("Document \(String(describing: object.id)) fetched successfully. 🎉")
                            promise(.success(object))
                        } else {
                            log.error("Document not found.")
                            promise(.failure(DatabaseError.documentNotFound))
                        }
                    } catch {
                        log.error("\(error.localizedDescription)")
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func observeAll<T: AccountDocument>(from collection: DatabaseCollection) -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()

        self.database.collection(collection.rawValue)
            .whereField("root_owner_uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    log.error("\(error.localizedDescription)")
                    subject.send(completion: .failure(error))
                } else if let querySnapshot {
                    let objects = querySnapshot.documents.compactMap { document -> T? in
                        try? document.data(as: T.self)
                    }
                    log.info("\(String(describing: objects.count)) documents fetched successfully. 🎉")
                    subject.send(objects)
                }
            }

        return subject.eraseToAnyPublisher()
    }

    public func update(data: some AccountDocument, in collection: DatabaseCollection) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(data.id!)

            do {
                try docRef.setData(from: data, merge: true) { error in
                    if let error {
                        log.error("\(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Document \(String(describing: data.id!)) updated successfully. 🎉")
                        promise(.success(()))
                    }
                }
            } catch {
                log.error("\(error.localizedDescription)")
                promise(.failure(DatabaseError.encodeError))
            }
        }
        .eraseToAnyPublisher()
    }

    public func delete(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(documentID)

            docRef.delete { error in
                if let error {
                    log.error("\(error.localizedDescription)")
                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
                } else {
                    log.info("Document \(String(describing: documentID)) deleted successfully. 🎉")
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Private

    private let database = Firestore.firestore()
}
