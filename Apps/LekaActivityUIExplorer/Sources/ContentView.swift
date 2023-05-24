// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    @State private var showInstructionModal: Bool = false
    @State private var navigateToConfigurator: Bool = false
    @State private var showOptions: Bool = false
    @State private var showNoDefaultsAlert: Bool = false

    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $navigator.sidebarVisibility) {
                SidebarView()
            } detail: {
                GameView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .principal) { navigationTitleView }
                        ToolbarItemGroup(placement: .navigationBarTrailing) { topBarTrailingItems }
                    }
                    .sheet(isPresented: $showInstructionModal) {
                        CurrentActivityInstructionView()
                    }
            }
            Color.black
                .opacity(showOptions ? 0.2 : 0.0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.4)) { showOptions = false }
                }
            Group {
                if showOptions {
                    ExplorerOptionsPanel(closePanel: $showOptions)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .animation(.easeIn(duration: 0.4), value: showOptions)
        .navigationSplitViewStyle(.prominentDetail)
        .alert("Valeurs par défaut :", isPresented: $showNoDefaultsAlert) {
            //
        } message: {
            Text("Ce template n'est pas modifiable.")
        }
    }

    private var topBarTrailingItems: some View {
        Group {
            infoButton
            optionsButton
        }
    }

    private var navigationTitleView: some View {
        HStack(spacing: 4) {
            Text(gameEngine.currentActivity.short.localized())
        }
        .font(defaults.semi17)
        .foregroundColor(.accentColor)
    }

    private var infoButton: some View {
        Button(
            action: {
                showInstructionModal.toggle()
            },
            label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.accentColor)
            }
        )
        .opacity(showInstructionModal ? 0 : 1)
    }

    private var optionsButton: some View {
        Button(
            action: {
                navigator.sidebarVisibility = .detailOnly
                guard configuration.currentDefaults != nil else {
                    showNoDefaultsAlert.toggle()
                    return
                }
                withAnimation(.easeIn(duration: 0.4)) {
                    showOptions.toggle()
                }
            },
            label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.accentColor)
            })
    }
}
