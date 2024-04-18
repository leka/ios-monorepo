// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct LekaLogo: View {
    // MARK: Lifecycle

    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
    }

    // MARK: Public

    public var body: some View {
        Image(
            DesignKitAsset.Assets.lekaLogo.name,
            bundle: Bundle(for: DesignKitResources.self)
        )
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: self.width, height: self.height)
    }

    // MARK: Private

    private let width: CGFloat?
    private let height: CGFloat?
}

#Preview {
    VStack {
        LekaLogo()

        Divider()
            .padding()
            .hidden()

        LekaLogo(width: 80)
        LekaLogo(width: 100)
        LekaLogo(width: 120)
        LekaLogo(width: 200)

        Divider()
            .padding()
            .hidden()

        LekaLogo(height: 80)
        LekaLogo(height: 100)
        LekaLogo(height: 120)
        LekaLogo(height: 200)
    }
}
