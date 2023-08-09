// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct InformationView: View {
    @StateObject var viewModel = InformationViewModel()
    @Binding var isConnectionViewPresented: Bool
    @Binding var isUpdateStatusViewPresented: Bool

    private var isViewVisible: Bool {
        !self.isConnectionViewPresented && !self.isUpdateStatusViewPresented
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        if viewModel.showRobotNeedsUpdate {
                            RobotNeedsUpdateIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text("⬆️ Une mise à jour est disponible 📦")
                                .font(.title2)
                        } else {
                            RobotUpToDateIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text("🤖 Votre robot est à jour ! 🎉 Vous n'avez rien à faire 👌")
                                .font(.title2)
                        }
                    }
                    .padding([.bottom], 10)

                    RobotInformationView()
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(DesignKitAsset.Colors.lightGray.swiftUIColor, lineWidth: 3)
                        )
                        .padding([.vertical], 10)

                    DisclosureGroup {
                        ChangelogView()
                            .padding()
                    } label: {
                        Text("Liste des changements apportés")
                            .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    }
                    .accentColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(DesignKitAsset.Colors.lightGray.swiftUIColor, lineWidth: 3)
                    )
                    .padding([.vertical], 10)

                    if viewModel.showRobotNeedsUpdate {
                        RobotUpdateAvailableView(isUpdateStatusViewPresented: $isUpdateStatusViewPresented)
                            .padding([.vertical], 10)
                    }

                    VStack {
                        LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .padding(35)

                        // TODO(@YannL): Remove DEBUG
                        Button("Switch (debug)", action: viewModel.switchRobotVersionForDebug)
                    }
                }
                .padding([.horizontal], 20)
                .background(Color.white)
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .onChange(of: isViewVisible) { isVisible in
                if isVisible { viewModel.onViewReappear() }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Leka Updater")
                            .font(.title2)
                            .bold()
                        Text("L'application pour mettre à jour vos robots Leka !")
                    }
                    .foregroundColor(.accentColor)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isConnectionViewPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Connexion")
                        }
                    }
                }
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    @State static var isConnectionViewPresented = false
    @State static var isUpdateStatusViewPresented = false

    static var previews: some View {
        InformationView(
            isConnectionViewPresented: $isConnectionViewPresented,
            isUpdateStatusViewPresented: $isUpdateStatusViewPresented
        )
        .onAppear {
            globalRobotManager.name = "Leka"
            globalRobotManager.battery = 75
            globalRobotManager.isCharging = true
            globalRobotManager.osVersion = "1.3.0"
        }
    }
}
