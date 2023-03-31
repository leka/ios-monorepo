// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

let dependencies = Dependencies(
	swiftPackageManager: [
		.remote(url: "https://github.com/jpsim/Yams", requirement: .upToNextMajor(from: "5.0.5")),
		.remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "4.1.3")),
		.remote(
			url: "https://github.com/StarryInternet/CombineCoreBluetooth", requirement: .upToNextMajor(from: "0.3.1")),
	],
	platforms: [.iOS]
)
