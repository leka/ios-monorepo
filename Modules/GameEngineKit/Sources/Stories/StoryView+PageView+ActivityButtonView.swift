// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SVGView
import SwiftUI

public extension StoryView.PageView {
    struct ActivityButtonView: View {
        // MARK: Lifecycle

        public init(payload: PagePayloadProtocol) {
            guard let payload = payload as? ActivityButtonPayload else {
                fatalError("💥 Story item is not ActivityButtonPayload")
            }
            if let path = Bundle.path(forImage: payload.image) {
                log.debug("Image found at path: \(path)")
                self.image = path
            } else {
                log.error("Image not found: \(payload.image)")
                self.image = payload.image
            }
            self.text = payload.text
            self.activity = Activity(id: payload.activity)!
        }

        // MARK: Public

        public var body: some View {
            VStack {
                Spacer()
                NavigationLink {
                    ActivityView(activity: self.activity)
                } label: {
                    if self.image.isRasterImageFile {
                        Image(uiImage: UIImage(named: self.image)!)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .padding(.top, 100)
                    } else if self.image.isVectorImageFile {
                        SVGView(contentsOf: URL(fileURLWithPath: self.image))
                            .frame(maxWidth: 200)
                            .padding(.top, 100)
                    }
                }
                Spacer()

                Text(self.text)
                    .font(Font(UIFont(name: "ChalkboardSE-Light", size: CGFloat(26)) ?? .systemFont(ofSize: 26)))
                    .foregroundStyle(.red)
                    .padding(.bottom, 100)
            }
        }

        // MARK: Private

        private let image: String
        private let text: String
        private let activity: Activity
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView.ActivityButtonView(payload: Story.mock.pages[4].items[2].payload)
    }
}
