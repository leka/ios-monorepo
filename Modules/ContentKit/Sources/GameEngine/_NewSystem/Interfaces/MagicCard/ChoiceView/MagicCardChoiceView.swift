// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SVGView
import SwiftUI

// MARK: - MagicCardChoiceView

struct MagicCardChoiceView: View {
    // MARK: Lifecycle

    init(magicCard: MagicCard, size: CGFloat, isTappable: Bool = true, background: Color? = nil) {
        guard let value = Bundle.path(forImage: magicCard.imageAssetName) else {
            logGEK.error("Image not found: \(magicCard.imageAssetName)")
            fatalError("💥️ Image not found: \(magicCard.imageAssetName)")
        }
        self.value = value
        self.size = size
        self.isTappable = isTappable
        self.background = background ?? self.choiceBackgroundColor
    }

    // MARK: Internal

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(self.choiceBackgroundColor)
            .overlay {
                if !FileManager.default.fileExists(atPath: self.value) {
                    self.imageNotFound()
                }

                if self.value.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.value)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(self.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if self.value.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.value))
                        .background(self.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .frame(
                width: self.size * 0.625,
                height: self.size
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(self.isTappable ? .clear : .white.opacity(0.6))
            )
            .animation(.easeOut(duration: 0.3), value: self.isTappable)
            .contentShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: Private

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let value: String
    private let size: CGFloat
    private let isTappable: Bool
    private let background: Color

    private func imageNotFound() -> some View {
        Text(l10n.ChoiceImageView.imageUnknownError(self.value))
            .multilineTextAlignment(.center)
            .frame(
                width: self.size * 0.6,
                height: self.size
            )
            .background(self.background)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 5)
            }
            .onAppear {
                logGEK.error("Image not found: \(self.value)")
            }
    }
}

#Preview {
    VStack(alignment: .center, spacing: 40) {
        HStack(spacing: 40) {
            MagicCardChoiceView(magicCard: MagicCard(name: "color_blue"), size: 200)
            MagicCardChoiceView(magicCard: MagicCard(name: "color_red"), size: 200)
            MagicCardChoiceView(magicCard: MagicCard(name: "color_yellow"), size: 200)
        }

        HStack(spacing: 40) {
            MagicCardChoiceView(magicCard: MagicCard(name: "number_1"), size: 200)
            MagicCardChoiceView(magicCard: MagicCard(name: "number_2"), size: 200)
        }
    }
}
