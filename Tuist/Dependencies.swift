//
//  Dependency.swift
//  Config
//
//  Created by Hugo Pezziardi on 21/03/2023.
//

import ProjectDescription

let dependencies = Dependencies(
	swiftPackageManager: [
		.remote(url: "https://github.com/jpsim/Yams", requirement: .upToNextMajor(from: "5.0.5")),
	],
	platforms: [.iOS]
)
