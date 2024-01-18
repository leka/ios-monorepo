// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

class CompanyManager {
    // MARK: Lifecycle

    init(databaseOperations: DatabaseOperations) {
        self.databaseOperations = databaseOperations
    }

    // MARK: Internal

    func observeCompanies() -> AnyPublisher<[Company], Error> {
        if let firestoreOperations = databaseOperations as? FirestoreDatabaseOperations {
            firestoreOperations.observe(.companies)
        } else {
            Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            // TODO(@macteuts): Return Fail below instead if Error handling is necessary here
            // return Fail(error: DatabaseError.customError("Real-time observation not supported."))
            //    .eraseToAnyPublisher()
        }
    }

    func fetchCompanyDetails(companyID: String) -> AnyPublisher<Company, Error> {
        self.databaseOperations.read(from: .companies, documentID: companyID)
    }

    func createCompany(_ company: Company) -> AnyPublisher<Company, Error> {
        self.databaseOperations.create(data: company, in: .companies)
    }

    func updateCompany(_ company: Company, companyID: String) -> AnyPublisher<Void, Error> {
        self.databaseOperations.update(data: company, in: .companies, documentID: companyID)
    }

    // temporary, due to the current architecture

    func fetchCompanyByOwnerUID(ownerUID: String) -> AnyPublisher<Company, Error> {
        self.databaseOperations.fetchCompanyByOwnerUID(ownerUID: ownerUID)
    }

    // MARK: Private

    private var databaseOperations: DatabaseOperations
    private var cancellables = Set<AnyCancellable>()
}
