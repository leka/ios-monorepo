// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct NoFeedback_ButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct BotStore: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot
    @ObservedObject var botVM: BotViewModel

    var body: some View {

        Group {
            if bleManager.peripherals.count < 1 {
                searchInvite
            } else if 1...3 ~= bleManager.peripherals.count {
                HStack(spacing: 160) {
                    Spacer()
                    availableBots
                    Spacer()
                }
                .onTapGesture {
                    botVM.currentlySelectedBotIndex = nil
                }
            } else {
                let rows = Array(repeating: GridItem(), count: 2)
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 200) {
                            availableBots
                        }
                    }
                    .onTapGesture {
                        botVM.currentlySelectedBotIndex = nil
                    }
                    ._safeAreaInsets(EdgeInsets(top: 0, leading: 110, bottom: 0, trailing: 80))
                    .onAppear {
                        guard botVM.currentlyConnectedBotIndex != nil else {
                            return
                        }
                        withAnimation { proxy.scrollTo(botVM.currentlyConnectedBotIndex, anchor: .center) }
                    }
                }
            }
        }
        .frame(height: 500)
    }

    private var availableBots: some View {
        ForEach(0..<bleManager.peripherals.count, id: \.self) { item in
            Button {
                botVM.currentlySelectedBotIndex = item
            } label: {
                if let advertisementData = AdvertisingData(bleManager.peripherals[item].advertisementData) {
                    BotFaceView(
                        isSelected: .constant(botVM.currentlySelectedBotIndex == item),
                        isConnected: .constant(botVM.currentlyConnectedBotIndex == item),
                        name: .constant(advertisementData.name),
                        battery: .constant(advertisementData.battery),
                        isCharging: .constant(advertisementData.isCharging),
                        osVersion: .constant(advertisementData.osVersion)
                    )
                }
            }
            .buttonStyle(NoFeedback_ButtonStyle())
            .id(item)
        }
    }

    private var searchInvite: some View {
        HStack {
            Spacer()
            VStack(spacing: 20) {
                Spacer()
                Image("magnifier")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    //					.frame(height: metrics.tilePictoHeightSmall)
                    .padding(.top, 10)
                Text("Lancer une recherche pour trouver les robots autour de vous !")
                    //					.font(metrics.reg17)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.accentColor)
                Spacer()
            }
            //			.frame(width: metrics.tileContentWidth)
            .offset(y: -160)
            Spacer()
        }
    }
}
