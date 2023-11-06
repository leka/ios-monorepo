// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

enum Version {
    case versionSelector
    case oldVersion
    case newVersion
}

class Router: ObservableObject {
    @Published var currentVersion: Version = .versionSelector
}

struct SwitchBoard: View {

    @EnvironmentObject var router: Router
    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    var body: some View {
        Group {
            switch router.currentVersion {
                case .versionSelector:
                    UIExplorerVersionSelector()
                        .transition(.opacity)
                case .oldVersion:
                    ContentViewOld()
                        .transition(.opacity)
                case .newVersion:
                    ContentView()
                        .transition(.opacity)
            }
        }
        .animation(.default, value: router.currentVersion)
        .preferredColorScheme(.light)
    }
}

struct UIExplorerVersionSelector: View {

    @EnvironmentObject var router: Router

    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 40)

            VStack(spacing: 20) {
                Text("Leka Activity UI Explorer")
                    .font(.largeTitle)
                Text("VERSION SELECTOR")
                    .font(.headline)
            }

            Spacer()

            HStack {
                Button {
                    router.currentVersion = .newVersion
                } label: {
                    VStack(spacing: 20) {
                        Image("dummy_2")
                            .resizable()
                            .activityIconImageModifier(diameter: 250, padding: 0)
                        Text("Nouvelle Version")
                            .font(.body)
                    }
                }
            }
            .frame(maxHeight: 300)

            Spacer()

            logoLeka
        }
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var logoLeka: some View {
        LekaActivityUIExplorerAsset.Images.lekaLogo.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.bottom, 40)
    }
}
