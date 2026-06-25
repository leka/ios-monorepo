// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SVGView
import SwiftUI

// MARK: - TTSChoiceViewImage

struct TTSChoiceViewImage: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat, background: Color? = nil) {
        guard let value = Bundle.path(forImage: value) else {
            logGEK.error("Image not found: \(value)")
            fatalError("💥️ Image not found: \(value)")
        }
        self.value = value
        self.size = size
        self.background = background ?? self.choiceBackgroundColor
    }

    // MARK: Internal

    var body: some View {
        Circle()
            .fill(self.choiceBackgroundColor)
            .overlay {
                if !FileManager.default.fileExists(atPath: self.value) {
                    self.imageNotFound()
                }

                if self.value.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.value)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.size, height: self.size)
                        .background(self.background)
                        .clipShape(Circle())
                }

                if self.value.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.value))
                        .frame(width: self.size, height: self.size)
                        .background(self.background)
                        .clipShape(Circle())
                }
            }
            .frame(
                width: self.size,
                height: self.size
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    // MARK: Private

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let value: String
    private let size: CGFloat
    private let background: Color

    private func imageNotFound() -> some View {
        Text(l10n.ChoiceImageView.imageUnknownError(self.value))
            .multilineTextAlignment(.center)
            .frame(
                width: self.size,
                height: self.size
            )
            .background(self.background)
            .overlay {
                Circle()
                    .stroke(Color.red, lineWidth: 5)
            }
            .onAppear {
                logGEK.error("Image not found: \(self.value)")
            }
    }
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 40) {
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_hortense", size: 200)
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_hugo", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_lucie", size: 200)
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_ladislas", size: 200)
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_yann", size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_hortense", size: 200)
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_lucie", size: 200)
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_ladislas", size: 200)
            TTSChoiceViewImage(value: "emotion_picture_adult_joy_yann", size: 200)
        }
    }
    .background(.lkBackground)
}
