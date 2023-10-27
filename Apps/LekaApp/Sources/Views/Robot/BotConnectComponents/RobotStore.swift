// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotStore: View {

    @ObservedObject var robotVM: RobotViewModel
    @EnvironmentObject var metrics: UIMetrics

    @Binding var allRobots: Int

    var body: some View {
        Group {
            if allRobots < 1 {
                searchInvite
            } else if 1...3 ~= allRobots {
                HStack(spacing: 160) {
                    Spacer()
                    availableRobots
                    Spacer()
                }
                .onTapGesture {
                    robotVM.currentlySelectedRobotIndex = nil
                }
            } else {
                let rows = Array(repeating: GridItem(), count: 2)
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 200) {
                            availableRobots
                        }
                    }
                    .onTapGesture {
                        robotVM.currentlySelectedRobotIndex = nil
                    }
                    ._safeAreaInsets(EdgeInsets(top: 0, leading: 110, bottom: 0, trailing: 80))
                    .onAppear {
                        guard robotVM.currentlyConnectedRobotIndex != nil else {
                            return
                        }
                        withAnimation { proxy.scrollTo(robotVM.currentlyConnectedRobotIndex, anchor: .center) }
                    }
                }
            }
        }
        .frame(height: 500)
    }

    private var availableRobots: some View {
        ForEach(1...allRobots, id: \.self) { item in
            Button {
                robotVM.currentlySelectedRobotIndex = item
            } label: {
                RobotFaceView(
                    isSelected: .constant(robotVM.currentlySelectedRobotIndex == item),
                    isConnected: .constant(robotVM.currentlyConnectedRobotIndex == item),
                    name: .constant("LKAL \(item)"))
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
                    .frame(height: metrics.tilePictoHeightSmall)
                    .padding(.top, 10)
                Text("Lancer une recherche pour trouver les robots autour de vous !")
                    .font(metrics.reg17)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                Spacer()
            }
            .frame(width: metrics.tileContentWidth)
            .offset(y: -160)
            Spacer()
        }
    }
}
