// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotPicker: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var robotVM: RobotViewModel
    @Environment(\.dismiss) var dismiss

    @State private var searchBtnLabel: String = "Rechercher"
    @State private var allRobots: Int = 0

    // ? For testing
    func resetForTests() {
        robotVM.robotIsConnected = false
        robotVM.currentlyConnectedRobotIndex = nil
        robotVM.currentlySelectedRobotIndex = nil
    }

    var body: some View {
        ZStack(alignment: .center) {
            CloudsBGView()
                .onTapGesture {
                    robotVM.currentlySelectedRobotIndex = nil
                }

            VStack {
                Spacer()

                RobotStore(robotVM: robotVM, allRobots: $allRobots)
                    .onAppear {
                        robotVM.currentlySelectedRobotIndex = nil
                        allRobots = 13  // For the tests
                    }

                HStack(spacing: 60) {
                    Spacer()
                    searchButton
                    connectionButton
                    Spacer()
                }
                .padding(.vertical, 20)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) { navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { closeButton }
            if navigationVM.showActivitiesFullScreenCover {
                ToolbarItem(placement: .navigationBarTrailing) { continueButton }
            }
        }
    }

    private var searchButton: some View {
        Button(
            action: {
                // ? For testing
                searchBtnLabel = "Recherche en cours..."
                resetForTests()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if allRobots < 3 {
                        allRobots += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            searchBtnLabel = "Rechercher"
                        }
                    } else if allRobots == 3 {
                        allRobots = 13
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            searchBtnLabel = "Rechercher"
                        }
                    } else {
                        allRobots = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            searchBtnLabel = "Rechercher"
                        }
                    }
                }
            },
            label: {
                Text(searchBtnLabel)
                    .font(metrics.bold15)
                    .padding(6)
                    .frame(width: 210)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
        .disabled(searchBtnLabel == "Recherche en cours...")

    }

    private var connectionButton: some View {
        Button(
            action: {
                if robotVM.currentlyConnectedRobotIndex == robotVM.currentlySelectedRobotIndex {
                    robotVM.currentlyConnectedRobotIndex = nil
                    robotVM.currentlySelectedRobotIndex = nil
                    robotVM.currentlyConnectedRobotName = ""
                    robotVM.robotIsConnected = false
                } else {
                    robotVM.currentlyConnectedRobotIndex = robotVM.currentlySelectedRobotIndex
                    robotVM.currentlyConnectedRobotName =
                        "LKAL \(String(describing: robotVM.currentlyConnectedRobotIndex))"
                    robotVM.robotIsConnected = true

                    // delayed for now
                    guard navigationVM.showActivitiesFullScreenCover else {
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        guard robotVM.robotIsConnected else {
                            return
                        }
                        robotVM.userChoseToPlayWithoutRobot = false
                        navigationVM.showActivitiesFullScreenCover.toggle()
                    }
                }
            },
            label: {
                Group {
                    if robotVM.currentlyConnectedRobotIndex == robotVM.currentlySelectedRobotIndex {
                        Text("Se déconnecter")
                    } else {
                        Text("Se connecter")
                    }
                }
                .font(metrics.bold15)
                .padding(6)
                .frame(width: 210)

            }
        )
        .buttonStyle(.borderedProminent)
        .tint(
            robotVM.currentlyConnectedRobotIndex == robotVM.currentlySelectedRobotIndex
                ? DesignKitAsset.Colors.lekaOrange.swiftUIColor : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
        )
        .disabled(allRobots == 0)
        .disabled(robotVM.currentlySelectedRobotIndex == nil)  // For the tests
    }

    // Toolbar
    private var navigationTitle: some View {
        HStack(spacing: 4) {
            Text("Connectez-vous à votre robot")
            if settings.companyIsConnected && settings.exploratoryModeIsOn {
                Image(systemName: "binoculars.fill")
            }
        }
        .font(metrics.semi17)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var closeButton: some View {
        Button(
            action: {
                guard navigationVM.showActivitiesFullScreenCover else {
                    dismiss()
                    return
                }
                navigationVM.showActivitiesFullScreenCover = false
            },
            label: {
                Text("Fermer")
            }
        )
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var continueButton: some View {
        Button(
            action: {
                robotVM.userChoseToPlayWithoutRobot = true
                navigationVM.showActivitiesFullScreenCover = false
            },
            label: {
                Text("Continuer sans le robot")
            }
        )
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .opacity(robotVM.robotIsConnected ? 0 : 1)
        .animation(.default, value: robotVM.robotIsConnected)
    }
}

struct RobotsConnectView_Previews: PreviewProvider {
    static var previews: some View {
        RobotPicker()
            .environmentObject(RobotViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(NavigationViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
