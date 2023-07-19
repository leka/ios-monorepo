// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RemoteArrowButtonView: View {
    var image: String
    var color: Color

    var body: some View {
        Button {
            print("touched \(image)")
        } label: {
            Circle()
                .fill(.white)
                .frame(width: 200, height: 200)
                .overlay {
                    Image(systemName: image)
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: 80, height: 100)
                }
        }
    }
}

struct TriangleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteArrowButtonView(image: "arrow.up", color: .red)
    }
}
