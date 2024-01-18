// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - CreateCarereceiverView

struct CreateCarereceiverView: View {
    // MARK: Internal

    @ObservedObject var profilesVM: ProfilesViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 20) {
                GroupBox("Create Carereceiver") {
                    Picker("", selection: self.$newCarereceiver.avatar) {
                        Text("👧🏽").tag("girl")
                        Text("👦🏼").tag("boy")
                    }
                    .pickerStyle(.segmented)
                    TextField("Name", text: self.$newCarereceiver.name)
                        .padding(.vertical, 10)
                    Picker("Reinforcer", selection: self.$newCarereceiver.reinforcer) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    .pickerStyle(.segmented)
                }
                .textFieldStyle(.roundedBorder)

                Button {
                    self.profilesVM.registerNewCarereceiver(self.newCarereceiver)
                } label: {
                    Label("Add Carereceiver", systemImage: "person.crop.circle.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()

            if self.profilesVM.isUpdating {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView()
            }
        }
    }

    // MARK: Private

    @State private var newCarereceiver = Carereceiver(
        id: "",
        name: "",
        avatar: "",
        reinforcer: 0
    )
}

// MARK: - EditCarereceiverView

struct EditCarereceiverView: View {
    // MARK: Internal

    @ObservedObject var profilesVM: ProfilesViewModel
    @Binding var carereceiver: Carereceiver

    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 20) {
                GroupBox("Edit Carereceiver") {
                    Picker("", selection: self.$bufferCarereceiver.avatar) {
                        Text("👧🏽").tag("girl")
                        Text("👦🏼").tag("boy")
                    }
                    .pickerStyle(.segmented)
                    TextField("Name", text: self.$bufferCarereceiver.name)
                        .padding(.vertical, 10)
                    Picker("Reinforcer", selection: self.$bufferCarereceiver.reinforcer) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    .pickerStyle(.segmented)
                }
                .textFieldStyle(.roundedBorder)
                .onAppear {
                    self.bufferCarereceiver = self.carereceiver
                }

                HStack(spacing: 10) {
                    Button {
                        self.profilesVM.updateSelectedCarereceiver(self.bufferCarereceiver)
                    } label: {
                        Label("Save Changes", systemImage: "person.crop.circle.badge.checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Button {
                        self.profilesVM.deleteSelectedCarereceiver(self.carereceiver)
                    } label: {
                        Label("Delete Carereceiver", systemImage: "trash")
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

    @State private var bufferCarereceiver = Carereceiver(
        id: "",
        name: "",
        avatar: "",
        reinforcer: 0
    )
}

// MARK: - CarereceiversListView

struct CarereceiversListView: View {
    @ObservedObject var profilesVM: ProfilesViewModel

    var body: some View {
        NavigationStack {
            List(self.profilesVM.currentCompany.carereceivers, id: \.id) { user in
                NavigationLink(user.name) {
                    EditCarereceiverView(
                        profilesVM: self.profilesVM,
                        carereceiver: .constant(user)
                    )
                }
            }
            .navigationTitle("Edit Carereceivers")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
