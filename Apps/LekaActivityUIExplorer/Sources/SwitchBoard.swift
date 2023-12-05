// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

enum Version {
    case versionSelector
    case firstActivityModelIteration
    case gameEngineKitNewSystem
}

class Router: ObservableObject {
    @Published var currentVersion: Version = .versionSelector
}

struct SwitchBoard: View {

    @EnvironmentObject var router: Router

    var body: some View {
        Group {
            switch router.currentVersion {
                case .versionSelector:
                    UIExplorerVersionSelector()
                        .transition(.opacity)
                case .firstActivityModelIteration:
                    Text("No more content. Sorry ...")
                        .transition(.opacity)
                case .gameEngineKitNewSystem:
                    GEKNewSystemView()
                        .transition(.opacity)
            }
        }
        .animation(.default, value: router.currentVersion)
        .preferredColorScheme(.light)
    }
}

struct UIExplorerVersionSelector: View {

    @EnvironmentObject var router: Router

    @State var presentRobotConnection: Bool = false
    @State var presentDesignSystem: Bool = false

    var body: some View {
        VStack(spacing: 80) {
            VStack(spacing: 10) {
                Text("Leka Activity UI Explorer")
                    .font(.largeTitle)
                Text("VERSION SELECTOR")
                    .font(.headline)
            }

            VStack(spacing: 50) {
                HStack(spacing: 200) {
                    Button {
                        router.currentVersion = .gameEngineKitNewSystem
                    } label: {
                        VStack(spacing: 20) {
                            Image(systemName: "2.circle")
                                .resizable()
                                .scaledToFit()
                            Text("New GameEngineKit\nSystem")
                                .font(.body)
                        }
                    }
                }
                .frame(maxHeight: 300)

                Button("Connect Robot") {
                    print("connect robot")
                    presentRobotConnection.toggle()
                }
                .font(.title3)
                .buttonStyle(.robotControlBorderedButtonStyle(foreground: .green, border: .green))

                Button("Open Design System") {
                    presentDesignSystem.toggle()
                }
                .font(.title3)
                .buttonStyle(.robotControlBorderedButtonStyle(foreground: .blue, border: .blue))
            }

            logoLeka
        }
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .fullScreenCover(isPresented: $presentRobotConnection) {
            RobotConnectionView(viewModel: RobotConnectionViewModel())
        }
        .fullScreenCover(isPresented: $presentDesignSystem) {
            Text("Design System")
        }
    }

    private var logoLeka: some View {
        DesignKitAsset.Assets.lekaLogo.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.bottom, 40)
    }
}

#Preview {
    SwitchBoard()
        .environmentObject(Router())
}
