// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class CaregiverManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    @Published public var caregivers: [Caregiver] = []
    @Published public var currentCaregiver: Caregiver?
    @Published public var errorMessage: String = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let caregiverManager = CaregiverManager.shared

    private func subscribeToManager() {
        // Subscribe to caregivers updates
        self.caregiverManager.caregiversPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetchedCaregivers in
                self?.caregivers = fetchedCaregivers
            })
            .store(in: &self.cancellables)

        // Subscribe to current caregiver updates
        self.caregiverManager.currentCaregiverPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetchedCaregiver in
                self?.currentCaregiver = fetchedCaregiver
            })
            .store(in: &self.cancellables)

        // Subscribe to error updates
        self.caregiverManager.fetchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.errorMessage = "An error occurred: \(error.localizedDescription)"
            })
            .store(in: &self.cancellables)
    }
}
