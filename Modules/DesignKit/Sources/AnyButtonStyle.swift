// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct AnyButtonStyle: ButtonStyle {
    // MARK: Lifecycle

    public init(_ makeBody: @escaping (Configuration) -> AnyView) {
        self.makeBodyClosure = makeBody
    }

    // MARK: Public

    public func makeBody(configuration: Configuration) -> some View {
        self.makeBodyClosure(configuration)
    }

    // MARK: Private

    private let makeBodyClosure: (Configuration) -> AnyView
}
