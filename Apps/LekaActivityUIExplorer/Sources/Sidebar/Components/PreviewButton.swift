// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct PreviewButton: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    @Binding var item: Previewable
    var accessory: String?
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(
                action: {
                    // sidebar & selection
                    navigator.selectedTemplate = item.index
                    navigator.sidebarVisibility = .detailOnly

                    //
                    configuration.currentActivityType = item.type
                    configuration.currentInterface = item.interface
                    configuration.currentDefaults = item.defaults()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        action()
                    }
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
        return navigator.selectedTemplate == item.index
            && configuration.currentActivityType == item.type
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
