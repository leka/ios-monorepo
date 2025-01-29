// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAuth
import FirebaseFirestore

// MARK: - DatabaseOperations

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

    public func addItemToLibrary(
        documentID: String,
        fieldName: Library.EditableLibraryField,
        newItem: some Encodable
    ) -> Future<Void, Error> {
        Future { promise in
            do {
                let encodedItem = try Firestore.Encoder().encode(newItem)
                let collection = DatabaseCollection.libraries.rawValue
                let field = fieldName.rawValue
                let lastEditedAt = Library.EditableLibraryField.lastEditedAt.rawValue
                let documentRef = self.database.collection(collection).document(documentID)

                documentRef.updateData([
                    field: FieldValue.arrayUnion([encodedItem]),
                    lastEditedAt: FieldValue.serverTimestamp(),
                ]) { error in
                    if let error {
                        log.error("Failed to update field \(field) in document \(documentID) in collection \(collection): \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Successfully updated field \(field) in document \(documentID) in collection \(collection). 🎉")
                        promise(.success(()))
                    }
                }
            } catch {
                log.error("Encoding error for item: \(error.localizedDescription)")
                promise(.failure(DatabaseError.customError(error.localizedDescription)))
            }
        }
    }

    // original
    public func removeItemFromLibrary(
        documentID: String,
        fieldName: Library.EditableLibraryField,
        itemID: String
    ) -> Future<Void, Error> {
        Future { promise in
            let collection = DatabaseCollection.libraries.rawValue
            let field = fieldName.rawValue
            let lastEditedAt = Library.EditableLibraryField.lastEditedAt.rawValue
            let documentRef = self.database.collection(collection).document(documentID)

            documentRef.updateData([
                field: FieldValue.arrayRemove([itemID]),
                lastEditedAt: FieldValue.serverTimestamp(),
            ]) { error in
                if let error {
                    log.error("Failed to remove item with ID \(itemID) from field \(field) in document \(documentID) in collection \(collection): \(error.localizedDescription)")
                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
                } else {
                    log.info("Successfully removed item with ID \(itemID) from field \(field) in document \(documentID) in collection \(collection). 🎉")
                    promise(.success(()))
                }
            }
        }
    }

    // Remove item using Date converted to String (
    // savedActivity ONLY so far
    // Cf Codable extension for conversion and init(from: Decoder)
    public func removeItemWithStringDateFromLibrary(
        documentID: String,
        collection: DatabaseCollection = .libraries,
        fieldName: Library.EditableLibraryField,
        valueToRemove: some Encodable
    ) -> Future<Void, Error> {
        Future { promise in
            do {
                let encodedItem = try Firestore.Encoder().encode(valueToRemove)
                let documentRef = self.database.collection(collection.rawValue).document(documentID)

                documentRef.updateData([
                    fieldName.rawValue: FieldValue.arrayRemove([encodedItem]),
                    "last_edited_at": FieldValue.serverTimestamp(),
                ]) { error in
                    if let error {
                        log.error("Failed to remove item from field \(fieldName.rawValue) in document \(documentID) in collection \(collection.rawValue): \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Successfully removed item from field \(fieldName.rawValue) in document \(documentID) in collection \(collection.rawValue). 🎉")
                        promise(.success(()))
                    }
                }
            } catch {
                log.error("Encoding error for item: \(error.localizedDescription)")
                promise(.failure(DatabaseError.customError(error.localizedDescription)))
            }
        }
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

public extension DatabaseOperations {
    // Setup listeners for the curriculums sub-collection
    func listenToCurriculums(libraryID: String) -> AnyPublisher<[SavedCurriculum], Error> {
        let subject = PassthroughSubject<[SavedCurriculum], Error>()

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            subject.send(completion: .failure(DatabaseError.customError("User not authenticated")))
            return subject.eraseToAnyPublisher()
        }

        let listenerKey = "CURRICULUMS_LIBRARY_\(currentUserID)"
        if let existingListener = listenerRegistrations[listenerKey] {
            existingListener.remove()
            self.listenerRegistrations.removeValue(forKey: listenerKey)
        }

        let listener = self.database.collection(DatabaseCollection.libraries.rawValue)
            .document(libraryID)
            .collection("CURRICULUMS")
            .addSnapshotListener { snapshot, error in
                if let error {
                    log.error("Error listening to saved curriculums: \(error.localizedDescription)")
                    subject.send(completion: .failure(DatabaseError.customError(error.localizedDescription)))
                } else if let snapshot {
                    let curriculums = snapshot.documents.compactMap { document -> SavedCurriculum? in
                        try? document.data(as: SavedCurriculum.self)
                    }
                    log.info("Fetched \(curriculums.count) saved curriculums successfully.")
                    subject.send(curriculums)
                }
            }

        self.listenerRegistrations[listenerKey] = listener

        return subject.eraseToAnyPublisher()
    }

    //    func addCurriculumToLibrary(libraryID: String, curriculum: SavedCurriculum) -> AnyPublisher<Void, Error> {
    //        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
    //        let curriculumRef = libraryRef.collection("CURRICULUMS").document()
    //
    //        return Future<Void, Error> { promise in
    //            do {
    //                try curriculumRef.setData(from: curriculum) { error in
    //                    if let error {
    //                        log.error("Failed to add curriculum: \(error.localizedDescription)")
    //                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
    //                    } else {
    //                        log.info("Curriculum added successfully to library.")
    //                        promise(.success(()))
    //                    }
    //                }
    //            } catch {
    //                log.error("Failed to encode curriculum: \(error.localizedDescription)")
    //                promise(.failure(DatabaseError.encodeError))
    //            }
    //        }.eraseToAnyPublisher()
    //    }

    func addCurriculumToLibrary(libraryID: String, curriculum: SavedCurriculum) -> AnyPublisher<Void, Error> {
        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
        let curriculumsRef = libraryRef.collection("CURRICULUMS").document()

        return Future<Void, Error> { promise in
            let batch = self.database.batch()

            do {
                try batch.setData(from: curriculum, forDocument: curriculumsRef)

                batch.updateData(["last_edited_at": FieldValue.serverTimestamp()], forDocument: libraryRef)

                batch.commit { error in
                    if let error {
                        log.error("Failed to add curriculum and update last_edited_at: \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Curriculum added and library's last_edited_at updated successfully.")
                        promise(.success(()))
                    }
                }
            } catch {
                log.error("Failed to encode curriculum: \(error.localizedDescription)")
                promise(.failure(DatabaseError.encodeError))
            }
        }
        .eraseToAnyPublisher()
    }

    //    func removeCurriculumFromLibrary(libraryID: String, curriculumID: String) -> AnyPublisher<Void, Error> {
    //        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
    //        let curriculumsRef = libraryRef.collection("CURRICULUMS")
    //
    //        return Future<Void, Error> { promise in
    //            curriculumsRef.whereField("uuid", isEqualTo: curriculumID).getDocuments { snapshot, error in
    //                if let error {
    //                    log.error("Error fetching curriculum with UUID \(curriculumID): \(error.localizedDescription)")
    //                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
    //                    return
    //                }
    //
    //                guard let document = snapshot?.documents.first else {
    //                    log.error("No curriculum found with UUID \(curriculumID)")
    //                    promise(.failure(DatabaseError.documentNotFound))
    //                    return
    //                }
    //
    //                document.reference.delete { error in
    //                    if let error {
    //                        log.error("Failed to remove curriculum: \(error.localizedDescription)")
    //                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
    //                    } else {
    //                        log.info("Curriculum removed successfully from library.")
    //                        promise(.success(()))
    //                    }
    //                }
    //            }
    //        }.eraseToAnyPublisher()
    //    }

    func removeCurriculumFromLibrary(libraryID: String, curriculumID: String) -> AnyPublisher<Void, Error> {
        let libraryRef = self.database.collection(DatabaseCollection.libraries.rawValue).document(libraryID)
        let curriculumsRef = libraryRef.collection("CURRICULUMS")

        return Future<Void, Error> { promise in
            curriculumsRef.whereField("uuid", isEqualTo: curriculumID).getDocuments { snapshot, error in
                if let error {
                    log.error("Error fetching curriculum with UUID \(curriculumID): \(error.localizedDescription)")
                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    return
                }

                guard let document = snapshot?.documents.first else {
                    log.error("No curriculum found with UUID \(curriculumID)")
                    promise(.failure(DatabaseError.documentNotFound))
                    return
                }

                let curriculumDocRef = document.reference
                let batch = self.database.batch()

                batch.deleteDocument(curriculumDocRef)

                batch.updateData(["last_edited_at": FieldValue.serverTimestamp()], forDocument: libraryRef)

                batch.commit { error in
                    if let error {
                        log.error("Failed to remove curriculum and update last_edited_at: \(error.localizedDescription)")
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        log.info("Curriculum removed and library's last_edited_at updated successfully.")
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
