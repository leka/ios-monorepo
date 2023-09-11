// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    private func changeBatteryLevel() {
        if robotVM.robotIsCharging {
            if robotVM.robotChargeLevel == 100 {
                robotVM.robotIsCharging.toggle()  // off
            } else if robotVM.robotChargeLevel == 10 {
                robotVM.robotChargeLevel += 15
            } else {
                robotVM.robotChargeLevel += 25
            }
        } else {
            if robotVM.robotChargeLevel == 0 {
                robotVM.robotIsCharging.toggle()  // on
                robotVM.robotChargeLevel = 10  // trick to trigger change
            } else {
                robotVM.robotChargeLevel -= 25
            }
        }
    }

    var body: some View {
        Group {
            // Educ Content
            NavigationSplitView(columnVisibility: $sidebar.sidebarVisibility) {
                SidebarView()
            } detail: {
                NavigationStack(path: $sidebar.pathsFromHome) {
                    sidebar.allSidebarDestinationViews
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                toolbarTitle
                            }
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(
                                    action: { changeBatteryLevel() },
                                    label: {
                                        Text("Batterie")
                                    })
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                infoButton
                            }
                        }
                        .background(Color("lekaLightBlue").ignoresSafeArea())
                }
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $sidebar.showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $sidebar.showProfileEditor) {
            NavigationStack {
                ProfileEditorView()
            }
        }
        .fullScreenCover(isPresented: $sidebar.showRobotPicker) {
            NavigationStack {
                RobotPicker()
            }
        }
        .fullScreenCover(isPresented: $sidebar.showActivitiesFullScreenCover) {
            FullScreenCoverToGameView()
        }
        .alert("Voulez-vous quitter le mode exploratoire ?", isPresented: $settings.showSwitchOffExploratoryAlert) {
            Button(role: .destructive) {
                settings.exploratoryModeIsOn.toggle()
            } label: {
                Text("Quitter")
            }
        } message: {
            Text(
                // swiftlint:disable:next line_length
                "Vous êtes actuellement en mode exploratoire. Ce mode vous permet d'explorer les contenus éducatifs sans que l'utilisation ne soit enregistrée."
            )
        }
    }

    private var toolbarTitle: some View {
        HStack(spacing: 4) {
            Text(sidebar.setNavTitle())
            if settings.companyIsConnected && settings.exploratoryModeIsOn {
                Image(systemName: "binoculars.fill")
            }
        }
        .font(metrics.semi17)
        .foregroundColor(.accentColor)
    }

    private var infoButton: some View {
        Button {
            sidebar.updateShowInfo()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(.accentColor)
        }
        .opacity(sidebar.showInfo() ? 0 : 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SidebarViewModel())
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(CurriculumViewModel())
            .environmentObject(ActivityViewModel())
            .environmentObject(RobotViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
