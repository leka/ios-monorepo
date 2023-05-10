//
//  TemplateGroup.swift
//  LekaActivityUIExplorer
//
//  Created by Mathieu Jeannot on 10/5/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct ListenThenTouchToSelectNavigationGroup: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    @Binding var selected: Int
    let action: () -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(ListenThenTouchToSelectPreviews.allCases, id: \.rawValue) { item in
                Button(
                    action: {
                        selected = item.rawValue
                        configuration.currentActivityType = item.content.type
                        navigator.sidebarVisibility = .detailOnly
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            action()
                        }
                    },
                    label: {
                        ZStack(alignment: .topTrailing) {
                            Image(item.content.preview)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            Image(systemName: "speaker.wave.2.circle")
                                .font(defaults.reg18)
                                .foregroundColor(
                                    LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor
                                )
                                .padding(4)
                        }
                    }
                )
                .buttonStyle(
                    TemplatePreview_ButtonStyle(
                        isSelected: selected == item.rawValue,
                        name: item.content.preview)
                )
                .padding(20)
            }
        }
        .padding(20)
    }
}
