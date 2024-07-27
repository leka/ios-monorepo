// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CountdownView: View {
    // MARK: Lifecycle

    init(
        duration: TimeInterval,
        colors: [Color] = [.red, .orange, .green],
        isOpaque: Bool = true,
        action: @escaping () -> Void
    ) {
        self.duration = duration
        self.colors = colors
        self.isOpaque = isOpaque
        self.action = action
    }

    // MARK: Internal

    let duration: TimeInterval
    let colors: [Color]
    let isOpaque: Bool
    let action: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .leading, endPoint: .trailing)
                        .frame(width: geometry.size.width, height: self.height)
                        .opacity(self.isOpaque ? 1.0 : 0.6)
                        .mask {
                            HStack {
                                Rectangle()
                                    .frame(width: self.width, height: self.height)
                                    .onAppear {
                                        withAnimation(.linear(duration: self.duration)) {
                                            self.width = 0
                                            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                                                self.action()
                                            }
                                        }
                                    }
                                Spacer()
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: Private

    @State private var width: CGFloat = UIScreen.main.bounds.width

    private let height: CGFloat = 10
}

#Preview {
    CountdownView(duration: 10, colors: [.red, .orange, .green], isOpaque: true, action: {
        print("done")
    })
}
