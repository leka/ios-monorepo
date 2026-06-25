// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension ActionButtonView {
    struct ActionButtonPulse: View {
        // MARK: Lifecycle

        init(isPulsing: Bool) {
            self.isPulsing = isPulsing
        }

        // MARK: Internal

        let isPulsing: Bool

        var body: some View {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .frame(width: 130, height: 130)
                    .foregroundStyle(self.styleManager.accentColor!)
                    .scaleEffect(self.isPulsing ? 1.5 : 1)
                    .opacity(self.isPulsing ? 0 : 0.4)
                    .animation(self.isPulsing ? .easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.6) : .easeInOut(duration: 1), value: self.isPulsing)

                Circle()
                    .stroke(lineWidth: 20)
                    .frame(width: 130, height: 130)
                    .foregroundStyle(self.styleManager.accentColor!)
                    .scaleEffect(self.isPulsing ? 1.5 : 1)
                    .opacity(self.isPulsing ? 0 : 0.4)
                    .animation(self.isPulsing ? .easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.6) : .easeInOut(duration: 1), value: self.isPulsing)
            }
            .opacity(self.isPulsing ? 1 : 0)
        }

        // MARK: Private

        private var styleManager: StyleManager = .shared
    }
}

#Preview {
    @Previewable @State var isPulsing = true
    ZStack {
        ActionButtonView.ActionButtonPulse(isPulsing: isPulsing)
        Circle()
            .frame(width: 200, height: 200)
            .foregroundStyle(.blue)
            .shadow(radius: 25)
        Image(systemName: "plus.circle.fill")
            .font(.system(size: 180))
            .foregroundStyle(.white)
            .shadow(radius: 25)
            .onTapGesture {
                isPulsing.toggle()
            }
    }
}
