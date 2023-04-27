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
    @StateObject var xylophoneDefaults = XylophoneTemplatesDefaults()
    @StateObject var oneDefaults = DefaultsTemplateOne()
    @StateObject var twoDefaults = DefaultsTemplateTwo()
    @StateObject var threeDefaults = DefaultsTemplateThree()
    @StateObject var threeInlineDefaults = DefaultsTemplateThreeInline()
    @StateObject var fourDefaults = DefaultsTemplateFour()
    @StateObject var fourInlineDefaults = DefaultsTemplateFourInline()
    @StateObject var fiveDefaults = DefaultsTemplateFive()
    @StateObject var sixDefaults = DefaultsTemplateSix()

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
                    ExplorerOptionsPanel(templateDefaults: relevantDefaultsSet(), closePanel: $showOptions)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .animation(.easeIn(duration: 0.4), value: showOptions)
        .navigationSplitViewStyle(.prominentDetail)
        .environmentObject(oneDefaults)
        .environmentObject(twoDefaults)
        .environmentObject(threeDefaults)
        .environmentObject(threeInlineDefaults)
        .environmentObject(fourDefaults)
        .environmentObject(fourInlineDefaults)
        .environmentObject(fiveDefaults)
        .environmentObject(sixDefaults)
        .environmentObject(xylophoneDefaults)
    }

    private func relevantDefaultsSet() -> DefaultsTemplate {
        guard !gameEngine.allAnswers.isEmpty else {
            return oneDefaults
        }
        if gameEngine.allAnswers.count == 1 {
            return oneDefaults
        } else if gameEngine.allAnswers.count == 2 {
            return twoDefaults
        } else if gameEngine.allAnswers.count == 3 {
            guard configuration.preferred3AnswersLayout == .inline else {
                return threeDefaults
            }
            return threeInlineDefaults
        } else if gameEngine.allAnswers.count == 4 {
            guard configuration.preferred4AnswersLayout == .inline else {
                return fourDefaults
            }
            return fourInlineDefaults
        } else if gameEngine.allAnswers.count == 5 {
            return fiveDefaults
        } else {
            return sixDefaults
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
