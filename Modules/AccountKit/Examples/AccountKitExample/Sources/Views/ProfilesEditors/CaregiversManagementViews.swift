// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - CreateCaregiverView

struct CreateCaregiverView: View {
    // MARK: Internal

    @ObservedObject var profilesVM: ProfilesViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 20) {
                GroupBox("Create Caregiver") {
                    Picker("", selection: self.$newCaregiver.avatar) {
                        Text("👩🏽‍🦰").tag("woman")
                        Text("👨🏻").tag("man")
                    }
                    .pickerStyle(.segmented)
                    TextField("Name", text: self.$newCaregiver.name)
                        .padding(.vertical, 10)
                    TextField("Job", text: self.$newCaregiver.jobs[0])
                }
                .textFieldStyle(.roundedBorder)

                Button {
                    self.profilesVM.registerNewCaregiver(self.newCaregiver)
                } label: {
                    Label("Add Caregiver", systemImage: "person.crop.circle.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()
            .padding(.top, 60)

            if self.profilesVM.isUpdating {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView()
            }
        }
    }

    // MARK: Private

    @State private var newCaregiver = Caregiver(
        id: "",
        name: "",
        avatar: "",
        jobs: [""]
    )
}

// MARK: - EditCaregiverView

struct EditCaregiverView: View {
    // MARK: Internal

    @ObservedObject var profilesVM: ProfilesViewModel
    @Binding var caregiver: Caregiver

    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 20) {
                GroupBox("Edit Caregiver") {
                    Picker("", selection: self.$bufferCaregiver.avatar) {
                        Text("👩🏽‍🦰").tag("woman")
                        Text("👨🏻").tag("man")
                    }
                    .pickerStyle(.segmented)
                    TextField("Name", text: self.$bufferCaregiver.name)
                        .padding(.vertical, 10)
                    TextField("Job", text: self.$bufferCaregiver.jobs[0])
                }
                .textFieldStyle(.roundedBorder)
                .onAppear {
                    self.bufferCaregiver = self.caregiver
                }

                HStack(spacing: 10) {
                    Button {
                        self.profilesVM.updateSelectedCaregiver(self.bufferCaregiver)
                    } label: {
                        Label("Save Changes", systemImage: "person.crop.circle.badge.checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Button {
                        self.profilesVM.deleteSelectedCaregiver(self.caregiver)
                    } label: {
                        Label("Delete Caregiver", systemImage: "trash")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()

            if self.profilesVM.isUpdating {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView()
            }
        }
    }

    // MARK: Private

    @State private var bufferCaregiver = Caregiver(
        id: "",
        name: "",
        avatar: "",
        jobs: [""]
    )
}

// MARK: - CaregiversListView

struct CaregiversListView: View {
    @ObservedObject var profilesVM: ProfilesViewModel

    var body: some View {
        NavigationStack {
            List(self.profilesVM.currentCompany.caregivers, id: \.id) { user in
                NavigationLink(user.name) {
                    EditCaregiverView(
                        profilesVM: self.profilesVM,
                        caregiver: .constant(user)
                    )
                }
            }
            .navigationTitle("Edit Caregivers")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
