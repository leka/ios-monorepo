// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Firebase
import SwiftUI

public class ProfilesViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(userUID: String) {
        self.userUID = userUID
        let firestoreOperations = FirestoreDatabaseOperations()

        self.companyManager = CompanyManager(databaseOperations: firestoreOperations)
        self.caregiversManager = CaregiversManager(databaseOperations: firestoreOperations)
        self.carereceiversManager = CareReceiversManager(databaseOperations: firestoreOperations)

        self.observeCompanies()
    }

    // MARK: Public

    @Published public var userUID: String
    @Published public var currentCompany = Company(
        id: "",
        email: "",
        name: "",
        caregivers: [],
        carereceivers: []
    )

    // UI Updates
    @Published public var showEditCompany = false
    @Published public var showCreateCaregiver = false
    @Published public var showCreateCarereceiver = false
    @Published public var showEditCaregivers = false
    @Published public var showEditCarereceivers = false
    @Published public var isUpdating = false

    public func fetchCurrentCompanyDetails() {
        self.companyManager.fetchCompanyDetails(companyID: self.currentCompany.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching company details: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] company in
                self?.updateCurrentCompanyDetails(with: company)
            })
            .store(in: &self.cancellables)
    }

    public func createCompanyDocument() {
        let bufferCompany = self.currentCompany
        self.companyManager.createCompany(bufferCompany)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("Company document created successfully.")
                    case let .failure(error):
                        print("Error occurred while creating company document: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] newCompany in
                // TODO(@macteuts): Show user notification of success, + dismiss
                // Handle Navigation in the onBoarding
                self?.updateCurrentCompanyDetails(with: newCompany)
                self?.observeCompanies()
            })
            .store(in: &self.cancellables)
    }

    public func updateCompany() {
        self.isUpdating = true
        let updatedCompany = self.currentCompany
        self.companyManager.updateCompany(updatedCompany, companyID: self.currentCompany.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Company updated successfully.")
                    case let .failure(error):
                        print("Error updating company: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                self?.showEditCompany = false
            })
            .store(in: &self.cancellables)
    }

    // Temporarily fetch existing company this way

    public func fetchCompanyByOwnerUID(ownerUID: String) {
        self.companyManager.fetchCompanyByOwnerUID(ownerUID: ownerUID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error occurred while fetching company: \(error.localizedDescription)")
                    // TODO(@macteuts): Ask User to try again?
                }
            }, receiveValue: { [weak self] company in
                self?.updateCurrentCompanyDetails(with: company)
            })
            .store(in: &self.cancellables)
    }

    // MARK: - Caregivers Methods

    public func registerNewCaregiver(_ newCaregiver: Caregiver) {
        self.isUpdating = true
        self.caregiversManager.createCaregiver(newCaregiver)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Caregiver created successfully.")
                    case let .failure(error):
                        print("Error creating caregiver: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] newCaregiver in
                self?.currentCompany.caregivers.append(newCaregiver)
                self?.updateCompany()
                self?.showCreateCaregiver = false
            })
            .store(in: &self.cancellables)
    }

    public func updateSelectedCaregiver(_ caregiver: Caregiver) {
        self.isUpdating = true
        self.caregiversManager.updateCaregiver(caregiver, caregiverID: caregiver.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Caregiver updated successfully.")
                    case let .failure(error):
                        print("Error updating caregiver: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                if let index = self?.currentCompany.caregivers.firstIndex(where: { $0.id == caregiver.id }) {
                    self?.currentCompany.caregivers[index] = caregiver
                }
                self?.updateCompany()
                self?.showEditCaregivers = false
            })
            .store(in: &self.cancellables)
    }

    public func deleteSelectedCaregiver(_ caregiver: Caregiver) {
        self.isUpdating = true
        self.caregiversManager.deleteCaregiver(caregiverID: caregiver.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Caregiver deleted successfully.")
                    case let .failure(error):
                        print("Error deleting caregiver: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                if let index = self?.currentCompany.caregivers.firstIndex(where: { $0.id == caregiver.id }) {
                    self?.currentCompany.caregivers.remove(at: index)
                }
                self?.updateCompany()
                self?.showEditCaregivers = false
            })
            .store(in: &self.cancellables)
    }

    // MARK: - Carereceivers Methods

    public func registerNewCarereceiver(_ newCarereceiver: Carereceiver) {
        self.isUpdating = true
        self.carereceiversManager.createCarereceiver(newCarereceiver)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Carereceiver created successfully.")
                    case let .failure(error):
                        print("Error creating carereceiver: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] newCarereceiver in
                self?.currentCompany.carereceivers.append(newCarereceiver)
                self?.updateCompany()
                self?.showCreateCarereceiver = false
            })
            .store(in: &self.cancellables)
    }

    public func updateSelectedCarereceiver(_ carereceiver: Carereceiver) {
        self.isUpdating = true
        self.carereceiversManager.updateCarereceiver(carereceiver, carereceiverID: carereceiver.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Carereceiver updated successfully.")
                    case let .failure(error):
                        print("Error updating carereceiver: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                if let index = self?.currentCompany.carereceivers.firstIndex(where: { $0.id == carereceiver.id }) {
                    self?.currentCompany.carereceivers[index] = carereceiver
                }
                self?.updateCompany()
                self?.showEditCarereceivers = false
            })
            .store(in: &self.cancellables)
    }

    public func deleteSelectedCarereceiver(_ carereceiver: Carereceiver) {
        self.isUpdating = true
        self.carereceiversManager.deleteCarereceiver(carereceiverID: carereceiver.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUpdating = false
                switch completion {
                    case .finished:
                        print("Carereceiver deleted successfully.")
                    case let .failure(error):
                        print("Error deleting carereceiver: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                if let index = self?.currentCompany.carereceivers.firstIndex(where: { $0.id == carereceiver.id }) {
                    self?.currentCompany.carereceivers.remove(at: index)
                }
                self?.updateCompany()
                self?.showEditCarereceivers = false
            })
            .store(in: &self.cancellables)
    }

    // MARK: Private

    private var companyManager: CompanyManager
    private var caregiversManager: CaregiversManager
    private var carereceiversManager: CareReceiversManager
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Firestore Listeners

    private func observeCompanies() {
        self.companyManager.observeCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                // Handle completion/errors if necessary
            }, receiveValue: { [weak self] companyList in
                if let company = companyList.first(where: { $0.id == self?.currentCompany.id }) {
                    self?.currentCompany = company
                }
            })
            .store(in: &self.cancellables)
    }

    // MARK: - Company Methods

    private func updateCurrentCompanyDetails(with company: Company) {
        self.currentCompany = company
        // temporary
        guard !self.currentCompany.email.isEmpty else {
            self.currentCompany.email = (Auth.auth().currentUser?.email)!
            self.updateCompany()
            return
        }
    }
}
