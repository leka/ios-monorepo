// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    // MARK: Internal

    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Group {
            // Educ Content
            NavigationSplitView(columnVisibility: self.$navigationVM.sidebarVisibility) {
                SidebarView()
            } detail: {
                NavigationStack(path: self.$navigationVM.pathsFromHome) {
                    self.navigationVM.allSidebarDestinationViews
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(self.navigationVM.getNavTitle())
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                self.infoButton
                            }
                        }
                        .background(DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea())
                }
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: self.$navigationVM.showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: self.$navigationVM.showProfileEditor) {
            NavigationStack {
                ProfileEditorView()
            }
        }
        .fullScreenCover(isPresented: self.$navigationVM.showRobotPicker) {
            RobotConnectionView()
        }
        .fullScreenCover(isPresented: self.$navigationVM.showActivitiesFullScreenCover) {
            FullScreenCoverToGameView()
        }
        .alert("Voulez-vous quitter le mode exploratoire ?", isPresented: self.$settings.showSwitchOffExploratoryAlert) {
            Button(role: .destructive) {
                self.settings.exploratoryModeIsOn.toggle()
            } label: {
                Text("Quitter")
            }
        } message: {
            Text("""
                Vous êtes actuellement en mode exploratoire. \
                Ce mode vous permet d'explorer les contenus \
                éducatifs sans que l'utilisation ne soit enregistrée.
                """
            )
        }
    }

    // MARK: Private

    private var infoButton: some View {
        Button {
            self.navigationVM.updateShowInfo()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
        .opacity(self.navigationVM.showInfo() ? 0 : 1)
    }
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
