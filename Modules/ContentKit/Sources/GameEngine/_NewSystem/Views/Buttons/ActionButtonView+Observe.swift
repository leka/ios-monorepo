// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SVGView
import SwiftUI

// MARK: - ActionButtonView.ObserveButton

extension ActionButtonView {
    struct ObserveButton: View {
        // MARK: Lifecycle

        init(image: String) {
            if let imagePath = Bundle.path(forImage: image) {
                self.image = imagePath
                self.isSFSymbol = false
            } else if UIImage(systemName: image) != nil {
                self.image = image
                self.isSFSymbol = true
            } else {
                fatalError("Image not found: \(image)")
            }
        }

        // MARK: Internal

        let image: String
        let isSFSymbol: Bool

        var body: some View {
            Button {
                withAnimation {
                    self.imageWasTapped = true
                }
            } label: {
                Image(systemName: "eye")
                    .font(.system(size: 130))
                    .frame(width: 460, height: 460)
                    .opacity(self.imageWasTapped ? 0 : 1)
            }
            .disabled(self.imageWasTapped)
            .background {
                if self.isSFSymbol {
                    Image(systemName: self.image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .scaledToFit()
                        .padding(60)
                        .frame(width: 460, height: 460)
                        .foregroundStyle(.black)
                        .background(self.choiceBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                        .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
                } else {
                    if !FileManager.default.fileExists(atPath: self.image) {
                        self.imageNotFound()
                    }

                    if self.image.isRasterImageFile {
                        Image(uiImage: UIImage(named: self.image)!)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .scaledToFit()
                            .frame(width: 460, height: 460)
                            .background(self.choiceBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                            .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
                    }

                    if self.image.isVectorImageFile {
                        SVGView(contentsOf: URL(fileURLWithPath: self.image))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 460, height: 460)
                            .background(self.choiceBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                            .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
                    }
                }
            }
        }

        // MARK: Private

        @State private var imageWasTapped: Bool = false

        private let choiceBackgroundColor: Color = .init(
            light: .white,
            dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
        )

        private func imageNotFound() -> some View {
            Text("Image not found: \(self.image)")
                .multilineTextAlignment(.center)
                .frame(
                    width: 460,
                    height: 460
                )
                .background(self.choiceBackgroundColor)
                .overlay {
                    Circle()
                        .stroke(Color.red, lineWidth: 5)
                }
                .onAppear {
                    logGEK.error("Image not found: \(self.image)")
                }
        }
    }
}

// MARK: - l10n.ObserveButton

extension l10n {
    enum ObserveButton {
        static let imageUnknownError = LocalizedStringInterpolation("game_engine_kit.action_button_view.observe_button.image_unknown_error",
                                                                    bundle: ContentKitResources.bundle,
                                                                    value: "❌\nImage not found:\n%1$@",
                                                                    comment: "ObserveButton button label")
    }
}

#Preview {
    ScrollView {
        VStack {
            HStack {
                ActionButtonView.ObserveButton(image: "4.circle")
                ActionButtonView.ObserveButton(image: "4.circle")
            }
            HStack {
                ActionButtonView.ObserveButton(image: "pictograms-foods-fruits-banana_yellow-00FB")
                ActionButtonView.ObserveButton(image: "pictograms-foods-fruits-banana_yellow-00FB")
            }
        }
    }
}
