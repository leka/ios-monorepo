// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBarMarker: View {

    @State var color: Color = .white
    @State var isCurrent: Bool

    @State private var scale: CGFloat = 0

    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 3)
            .background(color, in: Circle())
            .overlay {
                currentExerciseIndicator
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(Animation.easeIn(duration: 0.5).delay(0.5)) {
                            scale = 1
                        }
                    }
            }
    }

    @ViewBuilder private var currentExerciseIndicator: some View {
        if isCurrent {
            Circle()
                .fill(DesignKitAsset.Colors.chevron.swiftUIColor)
                .padding(4)
        } else {
            EmptyView()
        }
    }
}
