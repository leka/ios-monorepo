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
                    navigator.selectedTemplate = item.index
                    configuration.currentActivityType = item.type
                    configuration.currentDefaults = item.defaults
                    navigator.sidebarVisibility = .detailOnly
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
                    isSelected: navigator.selectedTemplate == item.index,
                    name: item.preview)
            )
            .padding(20)

            previewButtonAccessory
        }
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
