// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var router: Router
    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    @State private var showInstructionModal: Bool = false

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            NavigationStack {
                let columns = Array(repeating: GridItem(), count: 3)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(Interfaces.allCases, id: \.self) { interface in
                            NavigationLink {
                                GameView()
                            } label: {
                                VStack(spacing: 20) {
                                    Image(interface.rawValue)
                                        .activityIconImageModifier(padding: 20)
                                    Text(interface.rawValue)
                                        .font(defaults.reg17)
                                        .foregroundColor(.accentColor)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: 200)
                                .padding(.bottom, 40)
                            }
                        }
                    }
                    .safeAreaInset(edge: .top) {
                        Color.clear
                            .frame(height: 40)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: { backButton })
                    ToolbarItem(placement: .principal) { navigationTitleView }
                    ToolbarItemGroup(placement: .navigationBarTrailing) { topBarTrailingItems }
                }
                .sheet(isPresented: $showInstructionModal) {
                    CurrentActivityInstructionView()
                }
            }
        }
        .overlay(
            optionalReinforcer
        )
    }

    @ViewBuilder
    private var optionalReinforcer: some View {
        if navigator.useGameFeedback {
            // use only this within LekaApp
            StepCompletionFeedbackView()
        } else {
            EmptyView()
        }
    }

    private var topBarTrailingItems: some View {
        Group {
            infoButton
            reinforcerButton
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

    private var reinforcerButton: some View {
        Button(
            action: {
                navigator.useGameFeedback.toggle()
                gameEngine.currentActivity = gameEngine.bufferActivity
            },
            label: {
                Image(systemName: navigator.useGameFeedback ? "livephoto" : "livephoto.slash")
                    .foregroundColor(.accentColor)
            }
        )
        .disabled(gameEngine.tapIsDisabled)
    }

    private var backButton: some View {
        Button(
            action: {
                router.currentVersion = .versionSelector
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Retour")
                }
            }
        )
        .tint(.accentColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Router())
            .environmentObject(NavigationManager())
            .environmentObject(GameEngine())
            .environmentObject(GameLayoutTemplatesDefaults())
            .environmentObject(GameLayoutTemplatesConfigurations())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
