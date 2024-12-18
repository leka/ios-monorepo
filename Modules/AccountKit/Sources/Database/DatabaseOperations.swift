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

    public static let shared = DatabaseOperations()

    public func create<T: DatabaseDocument>(data: T, in collection: DatabaseCollection) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
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
                        promise(.success(documentData))
                    }
                }
            } catch {
                log.error("\(error.localizedDescription)")
                promise(.failure(DatabaseError.encodeError))
            }
        }
        .eraseToAnyPublisher()
    }

    public func read<T: DatabaseDocument>(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<T, Error> {
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
                            log.info("Document \(String(describing: object.id)) fetched successfully from \(collection.rawValue). 🎉")
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

    public func observeAll<T: DatabaseDocument>(from collection: DatabaseCollection) -> AnyPublisher<[T], Error> {
        let subject = CurrentValueSubject<[T], Error>([])

        if let existingListener = listenerRegistrations[collection.rawValue] {
            existingListener.remove()
            self.listenerRegistrations.removeValue(forKey: collection.rawValue)
        }

        let listener = self.database.collection(collection.rawValue)
            .whereField("root_owner_uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    log.error("\(error.localizedDescription)")
                    subject.send(completion: .failure(error))
                } else if let querySnapshot {
                    let objects = querySnapshot.documents.compactMap { document -> T? in
                        try? document.data(as: T.self)
                    }
                    log.info("\(String(describing: objects.count)) \(collection.rawValue) documents fetched successfully. 🎉")
                    subject.send(objects)
                }
            }

        self.listenerRegistrations[collection.rawValue] = listener

        return subject.eraseToAnyPublisher()
    }

    public func getCurrentRootAccount() -> AnyPublisher<RootAccount, Error> {
        let subject = PassthroughSubject<RootAccount, Error>()

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            subject.send(completion: .failure(DatabaseError.customError("User not authenticated")))
            return subject.eraseToAnyPublisher()
        }

        if let existingListener = listenerRegistrations["ROOT_ACCOUNTS_\(currentUserID)"] {
            existingListener.remove()
            self.listenerRegistrations.removeValue(forKey: "ROOT_ACCOUNTS_\(currentUserID)")
        }

        let listener = self.database.collection(DatabaseCollection.rootAccounts.rawValue)
            .whereField("root_owner_uid", isEqualTo: currentUserID)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    log.error("\(error.localizedDescription)")
                    subject.send(completion: .failure(error))
                } else if let querySnapshot, let document = querySnapshot.documents.first {
                    do {
                        let rootAccount = try document.data(as: RootAccount.self)
                        log.info("Root account document fetched successfully for user \(currentUserID). 🎉")
                        subject.send(rootAccount)
                    } catch {
                        log.error("\(error.localizedDescription)")
                        subject.send(completion: .failure(error))
                    }
                } else {
                    log.error("Root account document not found for user \(currentUserID).")
                    subject.send(completion: .failure(DatabaseError.documentNotFound))
                }
            }

        self.listenerRegistrations["ROOT_ACCOUNTS_\(currentUserID)"] = listener

        return subject.eraseToAnyPublisher()
    }

    public func clearAllListeners() {
        for (_, registration) in self.listenerRegistrations {
            registration.remove()
        }
        self.listenerRegistrations.removeAll()
    }

    public func update<T: DatabaseDocument>(data: T, in collection: DatabaseCollection, ignoringFields: [String] = []) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(data.id!)

            do {
                var dataDict = try Firestore.Encoder().encode(data)

                for field in ignoringFields {
                    dataDict.removeValue(forKey: field)
                }

                docRef.updateData(dataDict) { error in
                    if let error {
                        log.error("Update failed for document \(String(describing: data.id!)): \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Document \(String(describing: data.id!)) updated successfully in \(collection.rawValue). 🎉")
                        promise(.success(data))
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
                    log.info("Document \(String(describing: documentID)) deleted successfully from \(collection.rawValue). 🎉")
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Private

    private let database = Firestore.firestore()
    private var listenerRegistrations = [String: ListenerRegistration]()
}
