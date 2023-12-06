// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Group {
            // Educ Content
            NavigationSplitView(columnVisibility: $navigationVM.sidebarVisibility) {
                SidebarView()
            } detail: {
                NavigationStack(path: $navigationVM.pathsFromHome) {
                    navigationVM.allSidebarDestinationViews
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                toolbarTitle
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                infoButton
                            }
                        }
                        .background(DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea())
                }
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $navigationVM.showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $navigationVM.showProfileEditor) {
            NavigationStack {
                ProfileEditorView()
            }
        }
        .fullScreenCover(isPresented: $navigationVM.showRobotPicker) {
            RobotConnectionView()
        }
        .fullScreenCover(isPresented: $navigationVM.showActivitiesFullScreenCover) {
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
            Text(navigationVM.setNavTitle())
            if settings.companyIsConnected, settings.exploratoryModeIsOn {
                Image(systemName: "binoculars.fill")
            }
        }
        .font(metrics.semi17)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var infoButton: some View {
        Button {
            navigationVM.updateShowInfo()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
        .opacity(navigationVM.showInfo() ? 0 : 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
