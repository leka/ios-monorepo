// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// TODO: (@ladislas) move to UtilsKit
public extension Bundle {
    static func path(forImage image: String, in bundle: Bundle? = nil) -> String? {
        let kImageExtensions = [
            ".activity.asset.png",
            ".activity.asset.jpg",
            ".activity.asset.jpeg",
            ".activity.asset.svg",
            ".activity.icon.png",
            ".activity.icon.jpg",
            ".activity.icon.jpeg",
            ".activity.icon.svg",
            ".curriculum.icon.png",
            ".curriculum.icon.jpg",
            ".curriculum.icon.jpeg",
            ".curriculum.icon.svg",
            "png",
            "jpg",
            "jpeg",
            "svg",
        ]

        for imageExtension in kImageExtensions {
            if let path = ContentKitResources.bundle.path(forResource: image, ofType: imageExtension) {
                return path
            }

            if let path = bundle?.path(forResource: image, ofType: imageExtension) {
                return path
            }

            if let path = Bundle.module.path(forResource: image, ofType: imageExtension) {
                return path
            }

            if let path = Bundle.main.path(forResource: image, ofType: imageExtension) {
                return path
            }
        }

        return nil
    }

    static func url(forAudio audio: String, in bundle: Bundle? = nil) -> URL? {
        let kAudioExtensions = [
            ".activity.mp3",
            ".activity.wav",
            "mp3",
            "wav",
        ]

        for audioExtension in kAudioExtensions {
            if let url = ContentKitResources.bundle.url(forResource: audio, withExtension: audioExtension) {
                return url
            }

            if let url = bundle?.url(forResource: audio, withExtension: audioExtension) {
                return url
            }

            if let url = Bundle.module.url(forResource: audio, withExtension: audioExtension) {
                return url
            }

            if let url = Bundle.main.url(forResource: audio, withExtension: audioExtension) {
                return url
            }
        }

        return nil
    }
}
