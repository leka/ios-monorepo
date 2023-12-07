// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

// MARK: - NoFeedback_ButtonStyle

struct NoFeedback_ButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

// MARK: - BotStore

struct BotStore: View {
    // MARK: Internal

    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot
    @ObservedObject var botVM: BotViewModel

    var body: some View {
        Group {
            if self.bleManager.peripherals.count < 1 {
                self.searchInvite
            } else if 1...3 ~= self.bleManager.peripherals.count {
                HStack(spacing: 160) {
                    Spacer()
                    self.availableBots
                    Spacer()
                }
                .onTapGesture {
                    self.botVM.currentlySelectedBotIndex = nil
                }
            } else {
                let rows = Array(repeating: GridItem(), count: 2)
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 200) {
                            self.availableBots
                        }
                    }
                    .onTapGesture {
                        self.botVM.currentlySelectedBotIndex = nil
                    }
                    ._safeAreaInsets(EdgeInsets(top: 0, leading: 110, bottom: 0, trailing: 80))
                    .onAppear {
                        guard self.botVM.currentlyConnectedBotIndex != nil else {
                            return
                        }
                        withAnimation { proxy.scrollTo(self.botVM.currentlyConnectedBotIndex, anchor: .center) }
                    }
                }
            }
        }
        .frame(height: 500)
    }

    // MARK: Private

    private var availableBots: some View {
        ForEach(0..<self.bleManager.peripherals.count, id: \.self) { item in
            Button {
                self.botVM.currentlySelectedBotIndex = item
            } label: {
                if let advertisementData = AdvertisingData(bleManager.peripherals[item].advertisementData) {
                    BotFaceView(
                        isSelected: .constant(self.botVM.currentlySelectedBotIndex == item),
                        isConnected: .constant(self.botVM.currentlyConnectedBotIndex == item),
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
