// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ContentView: View {

    @EnvironmentObject var router: Router
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    private var testActivity: [String] = ["Test Activity"]

    var body: some View {
        NavigationStack {
            let columns = Array(repeating: GridItem(), count: 3)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(testActivity, id: \.self) { activity in
                        NavigationLink {
                            TestActivity()
                        } label: {
                            VStack(spacing: 20) {
                                Image(activity)
                                    .activityIconImageModifier(padding: 20)
                                Text(activity)
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
            .background(DesignKitAsset.Colors.lekaLightBlue.swiftUIColor)
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
