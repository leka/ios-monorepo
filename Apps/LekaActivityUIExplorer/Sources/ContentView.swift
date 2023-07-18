// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var router: Router
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        NavigationStack {
            Text("New UI")
                .font(defaults.reg17)
                .foregroundColor(.accentColor)
                .background(Color("lekaLightBlue"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: { backButton })
                    ToolbarItem(placement: .principal) { navigationTitleView }
                }
        }
    }

    private var navigationTitleView: some View {
        HStack(spacing: 4) {
            Text(gameEngine.currentActivity.short.localized())
        }
        .font(defaults.semi17)
        .foregroundColor(.accentColor)
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
            .environmentObject(GameEngine())
            .environmentObject(GameLayoutTemplatesDefaults())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
