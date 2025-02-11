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

    public func update(id: String, data: [String: Any], collection: DatabaseCollection) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(id)

            var updatedData = data
            updatedData["last_edited_at"] = FieldValue.serverTimestamp()

            docRef.updateData(updatedData) { error in
                if let error {
                    log.error("Update failed for document \(id): \(error.localizedDescription)")
                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
                } else {
                    log.info("Document \(id) updated successfully in \(collection.rawValue). 🎉")
                    promise(.success(()))
                }
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

    public func getCurrentLibrary() -> AnyPublisher<Library, Error> {
        let subject = PassthroughSubject<Library, Error>()

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            subject.send(completion: .failure(DatabaseError.customError("User not authenticated")))
            return subject.eraseToAnyPublisher()
        }

        let listenerKey = "LIBRARIES_QUERY_\(currentUserID)"
        if let existingListener = listenerRegistrations[listenerKey] {
            existingListener.remove()
            self.listenerRegistrations.removeValue(forKey: listenerKey)
        }

        let listener = self.database.collection(DatabaseCollection.libraries.rawValue)
            .whereField("root_owner_uid", isEqualTo: currentUserID)
            .limit(to: 1)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    log.error("\(error.localizedDescription)")
                    subject.send(completion: .failure(error))
                } else if let querySnapshot, !querySnapshot.documents.isEmpty {
                    do {
                        let library = try querySnapshot.documents.first?.data(as: Library.self)
                        if let library {
                            log.info("Library document fetched successfully for user \(currentUserID). 🎉")
                            subject.send(library)
                        } else {
                            log.error("Library document could not be decoded.")
                            subject.send(completion: .failure(DatabaseError.decodeError))
                        }
                    } catch {
                        log.error("\(error.localizedDescription)")
                        subject.send(completion: .failure(error))
                    }
                } else {
                    log.error("Library document not found for user \(currentUserID).")
                    subject.send(completion: .failure(DatabaseError.documentNotFound))
                }
            }

        self.listenerRegistrations[listenerKey] = listener

        return subject.eraseToAnyPublisher()
    }

    public func listenToAllLibrarySubCollections(libraryID: String) -> AnyPublisher<([SavedCurriculum], [SavedActivity], [SavedStory]), Error> {
        let curriculumPublisher: AnyPublisher<[SavedCurriculum], Error> = self.listenToLibrarySubCollection(libraryID: libraryID, subCollection: .curriculums)
        let activityPublisher: AnyPublisher<[SavedActivity], Error> = self.listenToLibrarySubCollection(libraryID: libraryID, subCollection: .activities)
        let storyPublisher: AnyPublisher<[SavedStory], Error> = self.listenToLibrarySubCollection(libraryID: libraryID, subCollection: .stories)

        return Publishers.CombineLatest(curriculumPublisher,
                                        Publishers.CombineLatest(activityPublisher, storyPublisher))
            .map { curriculums, combined in
                let (activities, stories) = combined
                return (curriculums, activities, stories)
            }
            .eraseToAnyPublisher()
    }

    public func getCurrentRootAccount() -> AnyPublisher<RootAccount, Error> {
        let subject = PassthroughSubject<RootAccount, Error>()

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            subject.send(completion: .failure(DatabaseError.customError("User not authenticated")))
            return subject.eraseToAnyPublisher()
        }

        let listenerKey = "ROOT_ACCOUNTS_\(currentUserID)"
        if let existingListener = listenerRegistrations[listenerKey] {
            existingListener.remove()
            self.listenerRegistrations.removeValue(forKey: listenerKey)
        }

        let listener = self.database.collection(DatabaseCollection.rootAccounts.rawValue)
            .whereField("root_owner_uid", isEqualTo: currentUserID)
            .limit(to: 1)
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

        self.listenerRegistrations[listenerKey] = listener

        return subject.eraseToAnyPublisher()
    }

    public func clearAllListeners() {
        for (_, registration) in self.listenerRegistrations {
            registration.remove()
        }
        self.listenerRegistrations.removeAll()
    }

    public func addItemToLibrarySubCollection(
        libraryID: String,
        subCollection: LibrarySubCollection,
        item: some Encodable
    ) -> AnyPublisher<Void, Error> {
        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
        let itemRef = libraryRef.collection(subCollection.rawValue).document()

        return Future<Void, Error> { promise in
            let batch = self.database.batch()
            do {
                try batch.setData(from: item, forDocument: itemRef)

                batch.updateData(
                    [Library.CodingKeys.lastEditedAt.rawValue: FieldValue.serverTimestamp()],
                    forDocument: libraryRef
                )

                batch.commit { error in
                    if let error {
                        log.error("Failed to add item to sub-collection \(subCollection.rawValue) and update last_edited_at: \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Item added to sub-collection \(subCollection.rawValue) and library's last_edited_at updated successfully.")
                        promise(.success(()))
                    }
                }
            } catch {
                log.error("Failed to encode item for sub-collection \(subCollection.rawValue): \(error.localizedDescription)")
                promise(.failure(DatabaseError.encodeError))
            }
        }
        .eraseToAnyPublisher()
    }

    public func removeItemFromLibrarySubCollection(
        libraryID: String,
        subCollection: LibrarySubCollection,
        itemID: String
    ) -> AnyPublisher<Void, Error> {
        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
        let subCollectionRef = libraryRef.collection(subCollection.rawValue)

        return Future<Void, Error> { promise in
            subCollectionRef
                .whereField("uuid", isEqualTo: itemID)
                .getDocuments { snapshot, error in
                    if let error {
                        log.error("Error fetching item with uuid \(itemID) from sub-collection \(subCollection.rawValue): \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                        return
                    }

                    guard let document = snapshot?.documents.first else {
                        log.error("No item found with uuid \(itemID) in sub-collection \(subCollection.rawValue)")
                        promise(.failure(DatabaseError.documentNotFound))
                        return
                    }

                    let batch = self.database.batch()

                    batch.deleteDocument(document.reference)

                    batch.updateData(
                        [Library.CodingKeys.lastEditedAt.rawValue: FieldValue.serverTimestamp()],
                        forDocument: libraryRef
                    )

                    batch.commit { error in
                        if let error {
                            log.error("Failed to remove item with uuid \(itemID) from sub-collection \(subCollection.rawValue) and update last_edited_at: \(error.localizedDescription)")
                            promise(.failure(DatabaseError.customError(error.localizedDescription)))
                        } else {
                            log.info("Item with uuid \(itemID) removed from sub-collection \(subCollection.rawValue) and library's last_edited_at updated successfully.")
                            promise(.success(()))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    public func toggleLibraryItemFavoriteStatus(
        libraryID: String,
        subCollection: LibrarySubCollection,
        itemID: String
    ) -> AnyPublisher<Void, Error> {
        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
        let subCollectionRef = libraryRef.collection(subCollection.rawValue)

        return Future<Void, Error> { promise in
            subCollectionRef
                .whereField(SavedStory.CodingKeys.id.rawValue, isEqualTo: itemID)
                .getDocuments { snapshot, error in
                    if let error {
                        log.error("Error fetching item with uuid \(itemID) from \(subCollection.rawValue): \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                        return
                    }

                    guard let document = snapshot?.documents.first else {
                        log.error("No item found with uuid \(itemID) in sub-collection \(subCollection.rawValue)")
                        promise(.failure(DatabaseError.documentNotFound))
                        return
                    }

                    let currentIsFavorite = document.data()[SavedStory.CodingKeys.isFavorite.rawValue] as? Bool ?? false
                    let newFavoriteValue = !currentIsFavorite

                    let batch = self.database.batch()
                    batch.updateData(
                        [SavedStory.CodingKeys.isFavorite.rawValue: newFavoriteValue],
                        forDocument: document.reference
                    )
                    batch.updateData(
                        [Library.CodingKeys.lastEditedAt.rawValue: FieldValue.serverTimestamp()],
                        forDocument: libraryRef
                    )

                    batch.commit { error in
                        if let error {
                            log.error("Failed to update favorite status for item \(itemID): \(error.localizedDescription)")
                            promise(.failure(DatabaseError.customError(error.localizedDescription)))
                        } else {
                            log.info("Favorite status for item \(itemID) updated successfully.")
                            promise(.success(()))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Private

    private let database = Firestore.firestore()
    private var listenerRegistrations = [String: ListenerRegistration]()

    private func listenToLibrarySubCollection<T: Decodable>(
        libraryID: String,
        subCollection: LibrarySubCollection
    ) -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            subject.send(completion: .failure(DatabaseError.customError("User not authenticated")))
            return subject.eraseToAnyPublisher()
        }

        let listenerKey = "SUBCOLLECTION_\(subCollection.rawValue)_\(libraryID)_\(currentUserID)"
        if let existingListener = listenerRegistrations[listenerKey] {
            existingListener.remove()
            self.listenerRegistrations.removeValue(forKey: listenerKey)
        }

        let listener = self.database.collection(DatabaseCollection.libraries.rawValue)
            .document(libraryID)
            .collection(subCollection.rawValue)
            .addSnapshotListener { snapshot, error in
                if let error {
                    log.error("Error listening to \(subCollection.rawValue): \(error.localizedDescription)")
                    subject.send(completion: .failure(DatabaseError.customError(error.localizedDescription)))
                } else if let snapshot {
                    let items: [T] = snapshot.documents.compactMap { document in
                        try? document.data(as: T.self)
                    }
                    log.info("Fetched \(items.count) items from sub-collection \(subCollection.rawValue).")
                    subject.send(items)
                }
            }

        self.listenerRegistrations[listenerKey] = listener
        return subject.eraseToAnyPublisher()
    }
}
