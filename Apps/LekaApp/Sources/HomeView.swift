// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var botVM: BotViewModel
    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Group {
            // Educ Content
            NavigationSplitView(columnVisibility: $sidebar.sidebarVisibility) {
                SidebarView()
            } detail: {
                NavigationStack {
                    sidebar.allSidebarDestinationViews
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                toolbarTitle
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
                BotPicker()
            }
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
            .environmentObject(ViewRouter())
            .environmentObject(CurriculumViewModel())
            .environmentObject(ActivityViewModel())
            .environmentObject(BotViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
