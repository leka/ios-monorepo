// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CompanyManager {
    // MARK: Lifecycle

    public init(databaseOperations: DatabaseOperations) {
        self.databaseOperations = databaseOperations
    }

    // MARK: Public

    public func testCompany(withID: String) {
        if let firestoreOperations = databaseOperations as? FirestoreDatabaseOperations {
            firestoreOperations.testFirestoreSecurityRules(withID: withID)
        }
    }

    public func observeCompanies() -> AnyPublisher<[Company], Error> {
        if let firestoreOperations = databaseOperations as? FirestoreDatabaseOperations {
            firestoreOperations.observe(.companies)
        } else {
            Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            // TODO(@macteuts): Return Fail below instead if Error handling is necessary here
            // return Fail(error: DatabaseError.customError("Real-time observation not supported."))
            //    .eraseToAnyPublisher()
        }
    }

    public func fetchCompanyDetails(companyID: String) -> AnyPublisher<Company, Error> {
        self.databaseOperations.read(from: .companies, documentID: companyID)
    }

    public func createCompany(_ company: Company) -> AnyPublisher<Company, Error> {
        self.databaseOperations.create(data: company, in: .companies)
    }

    public func updateCompany(_ company: Company, companyID: String) -> AnyPublisher<Void, Error> {
        self.databaseOperations.update(data: company, in: .companies, documentID: companyID)
    }

    // temporary, due to the current architecture

    public func fetchCompanyByOwnerUID(ownerUID: String) -> AnyPublisher<Company, Error> {
        self.databaseOperations.fetchCompanyByOwnerUID(ownerUID: ownerUID)
    }

    // MARK: Private

    private var databaseOperations: DatabaseOperations
    private var cancellables = Set<AnyCancellable>()
}
