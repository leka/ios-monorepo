// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct PreviewButton: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine

    @Binding var item: Previewable
    var accessory: String?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(
                action: {
                    // sidebar & selection
                    navigator.sidebarVisibility = .detailOnly

                    // set defaults for editor
                    configuration.currentDefaults = item.defaults()

                    // set activity
                    gameEngine.bufferActivity = ExplorerActivity(
                        type: item.type,
                        interface: item.interface
                    )
                    .makeActivity()
                    gameEngine.setupGame()
                },
                label: {
                    Image(item.preview)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            )
            .buttonStyle(
                TemplatePreview_ButtonStyle(
                    isSelected: isSelected,
                    name: item.preview)
            )
            .padding(20)

            previewButtonAccessory
        }
    }

    private var isSelected: Bool {
        return item.interface == gameEngine.interface
    }

    @ViewBuilder
    private var previewButtonAccessory: some View {
        if accessory != nil {
            Image(systemName: accessory!)
                .font(defaults.reg18)
                .foregroundColor(
                    LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor
                )
                .padding(24)
        } else {
            EmptyView()
        }
    }
}
