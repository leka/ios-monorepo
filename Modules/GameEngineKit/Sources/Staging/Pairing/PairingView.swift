// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - Action

private enum Action {
    case play
    case pause
    case stop

    // MARK: Public

    public func icon(_ stopButtonDisabled: Bool) -> some View {
        switch self {
            case .play:
                Image(systemName: "play.circle.fill")
                    .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    .font(.system(size: 150))
            case .pause:
                Image(systemName: "pause.circle.fill")
                    .foregroundStyle(DesignKitAsset.Colors.btnDarkBlue.swiftUIColor)
                    .font(.system(size: 150))
            case .stop:
                Image(systemName: "stop.circle.fill")
                    .foregroundStyle(
                        stopButtonDisabled
                            ? DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                            : DesignKitAsset.Colors.lekaOrange.swiftUIColor
                    )
                    .font(.system(size: 150))
        }
    }

    public func text() -> String {
        switch self {
            case .play:
                "Play"
            case .pause:
                "Pause"
            case .stop:
                "Stop"
        }
    }
}

// MARK: - PairingView

public struct PairingView: View {
    // MARK: Lifecycle

    public init() {
        // Nothing to do
    }

    // MARK: Public

    public var body: some View {
        VStack {
            Text(
                """
                Le mode Pairing permet à la personne accompagnée de se familiariser à Leka
                avant même d'entrer dans les apprentissages des Activités et des Parcours.

                Le robot va s'animer en faisant des pauses afin que la personne accompagnée puisse
                apprivoiser son nouveau compagnon !
                """
            )
            .font(.title2)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
            .multilineTextAlignment(.center)
            .padding(.vertical, 50)

            HStack(spacing: 180) {
                if playButtonVisible {
                    actionButton(.play)
                } else {
                    actionButton(.pause)
                }

                actionButton(.stop)
                    .disabled(stopButtonDisabled)
            }
        }
    }

    // MARK: Private

    @State private var stopButtonDisabled: Bool = true
    @State private var playButtonVisible: Bool = true

    private func actionButton(_ action: Action) -> some View {
        VStack {
            Button {
                switch action {
                    case .play:
                        // TODO(@ladislas): Play pairing behavior
                        print("Pairing behavior is running")
                        stopButtonDisabled = false
                        playButtonVisible.toggle()
                    case .pause:
                        // TODO(@ladislas): Pause pairing behavior
                        print("Pairing behavior is pausing")
                        playButtonVisible.toggle()
                    case .stop:
                        // TODO(@ladislas): Stop pairing behavior and restart pairing behavior
                        print("Pairing behavior stopped")
                        playButtonVisible = true
                        stopButtonDisabled = true
                }
            } label: {
                action.icon(stopButtonDisabled)
            }

            .background(
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.5), radius: 7, x: 0, y: 4)
            )

            Text(action.text())
                .font(.title2)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.vertical, 10)
        }
    }
}
