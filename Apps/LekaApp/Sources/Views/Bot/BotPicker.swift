// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BotPicker: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var botVM: BotViewModel
    @Environment(\.dismiss) var dismiss

    @State private var searchBtnLabel: String = "Rechercher"
    @State private var allBots: Int = 0

    // ? For testing
    func resetForTests() {
        botVM.botIsConnected = false
        botVM.currentlyConnectedBotIndex = nil
        botVM.currentlySelectedBotIndex = nil
    }

    var body: some View {
        ZStack(alignment: .center) {
            CloudsBGView()
                .onTapGesture {
                    botVM.currentlySelectedBotIndex = nil
                }

            VStack {
                Spacer()

                BotStore(botVM: botVM, allBots: $allBots)
                    .onAppear {
                        allBots = 13  // For the tests
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
        .toolbar {
            ToolbarItem(placement: .principal) { navigationTitle }
            ToolbarItem(placement: .navigationBarTrailing) { closeButton }
        }
    }

    private var searchButton: some View {
        Button(
            action: {
                // ? For testing
                searchBtnLabel = "Recherche en cours..."
                resetForTests()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if allBots < 3 {
                        allBots += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            searchBtnLabel = "Rechercher"
                        }
                    } else if allBots == 3 {
                        allBots = 13
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            searchBtnLabel = "Rechercher"
                        }
                    } else {
                        allBots = 0
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
        .tint(Color("lekaSkyBlue"))
        .disabled(searchBtnLabel == "Recherche en cours...")

    }

    private var connectionButton: some View {
        Button(
            action: {
                if botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex {
                    botVM.currentlyConnectedBotIndex = nil
                    botVM.currentlyConnectedBotName = ""
                    botVM.botIsConnected = false
                } else {
                    botVM.currentlyConnectedBotIndex = botVM.currentlySelectedBotIndex
                    botVM.currentlyConnectedBotName = "LKAL \(String(describing: botVM.currentlyConnectedBotIndex))"
                    botVM.botIsConnected = true
                }
            },
            label: {
                Group {
                    if botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex {
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
        .tint(botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex ? Color("lekaOrange") : .accentColor)
        .disabled(allBots == 0)
        .disabled(botVM.currentlySelectedBotIndex == nil)  // For the tests
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
        .foregroundColor(.accentColor)
    }

    private var closeButton: some View {
        Button(
            action: {
                dismiss()
            },
            label: {
                Text("Fermer")
            }
        )
        .tint(.accentColor)
    }
}

struct BotsConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BotPicker()
            .environmentObject(BotViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(ViewRouter())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
