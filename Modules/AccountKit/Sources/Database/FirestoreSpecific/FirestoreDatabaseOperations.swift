// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAuth
import FirebaseFirestore

// MARK: - FirestoreDatabaseOperations

class FirestoreDatabaseOperations: DatabaseOperations {
    // MARK: Internal

    // MARK: - Listeners Setup

    func observe<T: Decodable>(_ collection: DatabaseCollection) -> AnyPublisher<[T], Error> {
        let query = self.database.collection(collection.rawValue)
        return QuerySnapshotPublisher(query: query)
            .map { snapshot in
                snapshot.documents.compactMap { document in
                    try? document.data(as: T.self)
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - CRUD Methods

    func create<T: Codable>(data: T, in collection: DatabaseCollection) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            do {
                let docRef = self.database.collection(collection.rawValue).document()
                var jsonData = try JSONEncoder().encode(data)

                if var dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    dictionary["id"] = docRef.documentID
                    dictionary["root_owner_uid"] = Auth.auth().currentUser?.uid
                    jsonData = try JSONSerialization.data(withJSONObject: dictionary)
                }

                guard let finalDictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                    throw DatabaseError.encodeError
                }

                docRef.setData(finalDictionary) { error in
                    if let error {
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        do {
                            let createdObject = try JSONDecoder().decode(T.self, from: jsonData)
                            promise(.success(createdObject))
                        } catch {
                            promise(.failure(DatabaseError.decodeError))
                        }
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func read<T: Decodable>(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(documentID)
            docRef.getDocument { document, error in
                if let error {
                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    return
                }
                guard let document, document.exists, let data = document.data() else {
                    promise(.failure(DatabaseError.documentNotFound))
                    return
                }
                do {
                    let object = try JSONDecoder().decode(T.self, fromJSONObject: data)
                    promise(.success(object))
                } catch {
                    promise(.failure(DatabaseError.decodeError))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(data: some Encodable, in collection: DatabaseCollection, documentID: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                let docRef = self.database.collection(collection.rawValue).document(documentID)
                let jsonData = try JSONEncoder().encode(data)
                guard let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                    throw DatabaseError.encodeError
                }
                docRef.updateData(dictionary) { error in
                    if let error {
                        promise(.failure(DatabaseError.customError(error.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func delete(from collection: DatabaseCollection, documentID: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let docRef = self.database.collection(collection.rawValue).document(documentID)
            docRef.delete { error in
                if let error {
                    promise(.failure(DatabaseError.customError(error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // temporary, due to the current architecture

    func fetchCompanyByOwnerUID(ownerUID: String) -> AnyPublisher<Company, Error> {
        Future<Company, Error> { promise in
            self.database.collection("companies")
                .whereField("root_owner_uid", isEqualTo: ownerUID)
                .getDocuments { querySnapshot, error in
                    if let error {
                        promise(.failure(error))
                    } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                        let company = try? documents.first?.data(as: Company.self)
                        if let company {
                            promise(.success(company))
                        } else {
                            promise(.failure(DatabaseError.customError("Company not found")))
                        }
                    } else {
                        promise(.failure(DatabaseError.customError("No company associated with this user")))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Private

    private let database = Firestore.firestore()
}

// MARK: - JSON Decoder convenience decode

extension JSONDecoder {
    func decode<T: Decodable>(_: T.Type, fromJSONObject object: Any) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object)
        return try self.decode(T.self, from: data)
    }
}
