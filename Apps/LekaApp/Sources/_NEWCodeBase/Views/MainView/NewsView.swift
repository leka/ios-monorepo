// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - NewsView

struct NewsView: View {
    // MARK: Internal

    @StateObject var caregiverViewModel = CaregiverManagerViewModel()
    @StateObject var carereceiversViewModel = CarereceiverManagerViewModel()

    var body: some View {
        HStack {
            self.caregiversTests
            Divider()
            self.carereceiversTests
        }
    }

    // MARK: Private

    @State private var caregiverID = ""
    @State private var carereceiverID = ""
    private var caregiverManager = CaregiverManager.shared
    private var carereceiverManager = CarereceiverManager.shared

    private var caregiversTests: some View {
        VStack(spacing: 20) {
            Button("Create Caregiver") {
                let newCaregiver = Caregiver(
                    firstName: "John",
                    lastName: "Doe",
                    email: "john.doe@example.com",
                    avatar: "avatarURL",
                    professions: ["Nurse"],
                    colorScheme: .light,
                    colorTheme: .blue
                )

                self.caregiverManager.addCaregiver(caregiver: newCaregiver)
            }

            TextField("Enter Document ID", text: self.$caregiverID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Fetch Caregiver") {
                self.caregiverManager.fetchCaregiver(documentID: self.caregiverID)
            }

            Button("Update Caregiver") {
                guard self.caregiverViewModel.currentCaregiver != nil else {
                    print("ID is nil... No Caregiver")
                    return
                }
                var updatedCaregiver = self.caregiverViewModel.currentCaregiver!
                updatedCaregiver.firstName = "Updated"
                updatedCaregiver.lastName = "caregiver"

                self.caregiverManager.updateAndSelectCaregiver(caregiver: &updatedCaregiver)
            }

            if let caregiver = caregiverViewModel.currentCaregiver {
                Text("Fetched: \(caregiver.firstName) \(caregiver.lastName)")
            }
        }
        .padding()
    }

    private var carereceiversTests: some View {
        VStack(spacing: 20) {
            Button("Create Carereceiver") {
                let newCarereceiver = Carereceiver(username: "Bobby", avatar: "avatar", reinforcer: "rainbow")

                self.carereceiverManager.addCarereceiver(carereceiver: newCarereceiver)
            }

            TextField("Enter Document ID", text: self.$carereceiverID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Fetch Carereceiver") {
                self.carereceiverManager.fetchCarereceiver(documentID: self.carereceiverID)
            }

            Button("Update Carereceiver") {
                guard self.carereceiversViewModel.currentCarereceiver != nil else {
                    print("ID is nil... No Carereceiver")
                    return
                }
                var updatedCarereceiver = self.carereceiversViewModel.currentCarereceiver!
                updatedCarereceiver.username = "Updated"
                updatedCarereceiver.reinforcer = "Carereceiver"

                self.carereceiverManager.updateAndSelectCarereceiver(carereceiver: &updatedCarereceiver)
            }

            if let carereceiver = carereceiversViewModel.currentCarereceiver {
                Text("Fetched: \(carereceiver.username) \(carereceiver.reinforcer)")
            }
        }
        .padding()
    }
}
