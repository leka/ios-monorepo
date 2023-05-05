// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    // Templates defaults
    @StateObject var xylophoneDefaults = Misc.xylophone

    @State private var showInstructionModal: Bool = false
    @State private var navigateToConfigurator: Bool = false
    @State private var showOptions: Bool = false

    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $navigator.sidebarVisibility) {
                SidebarView()
            } detail: {
                GameView(templateDefaults: relevantDefaultsSet())
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
                    ExplorerOptionsPanel(
                        templateDefaults: relevantDefaultsSet(),
                        xylophoneDefaults: xylophoneDefaults,
                        closePanel: $showOptions
                    )
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .animation(.easeIn(duration: 0.4), value: showOptions)
        .navigationSplitViewStyle(.prominentDetail)
        .environmentObject(xylophoneDefaults)
    }

    private func relevantDefaultsSet() -> BaseDefaults {
        guard gameEngine.currentActivity.activityType != "listen_then_touch_to_select" else {
            return relevantListenThenTouchToSelectDefaults()
        }
        guard gameEngine.currentActivity.activityType != "color_quest" else {
            return relevantColorQuestDefaults()
        }
        return relevantTouchToSelectDefaults()
    }

    private func relevantTouchToSelectDefaults() -> BaseDefaults {
        guard gameEngine.allAnswers.count >= 2 else {
            return TouchToSelect.one
        }
        if gameEngine.allAnswers.count == 2 {
            return TouchToSelect.two
        } else if gameEngine.allAnswers.count == 3 {
            guard configuration.preferred3AnswersLayout == .inline else {
                return TouchToSelect.three
            }
            return TouchToSelect.threeInline
        } else if gameEngine.allAnswers.count == 4 {
            guard configuration.preferred4AnswersLayout == .inline else {
                return TouchToSelect.four
            }
            return TouchToSelect.fourInline
        } else if gameEngine.allAnswers.count == 5 {
            return TouchToSelect.five
        } else {
            return TouchToSelect.six
        }
    }

    private func relevantListenThenTouchToSelectDefaults() -> BaseDefaults {
        guard gameEngine.allAnswers.count >= 2 else {
            return TouchToSelect.one
        }
        if gameEngine.allAnswers.count == 2 {
            return ListenThenTouchToSelect.two
        } else if gameEngine.allAnswers.count == 3 {
            guard configuration.preferred3AnswersLayout == .inline else {
                return ListenThenTouchToSelect.three
            }
            return ListenThenTouchToSelect.threeInline
        } else if gameEngine.allAnswers.count == 4 {
            guard configuration.preferred4AnswersLayout == .inline else {
                return ListenThenTouchToSelect.four
            }
            return ListenThenTouchToSelect.fourInline
        } else {
            return ListenThenTouchToSelect.six
        }
    }

    private func relevantColorQuestDefaults() -> BaseDefaults {
        guard gameEngine.allAnswers.count >= 2 else {
            return ColorQuest.one
        }
        if gameEngine.allAnswers.count == 2 {
            return ColorQuest.two
        }
        return ColorQuest.three
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
                withAnimation(.easeIn(duration: 0.4)) {
                    showOptions.toggle()
                }
                navigator.sidebarVisibility = .detailOnly
            },
            label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.accentColor)
            })
    }
}
