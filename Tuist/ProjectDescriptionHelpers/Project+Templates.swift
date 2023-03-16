import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

let scripts: [TargetScript] = [
	.swiftLint,
	.swiftFormat,
]

extension Project {

	/// Helper function to create the Project for this ExampleApp
	public static func app(name: String,
						   platform: Platform,
						   dependencies: [TargetDependency],
						   infoPlist: [String: InfoPlist.Value] = [:]) -> Project {
		let targets = makeAppTargets(name: name,
									 platform: platform,
									 dependencies: dependencies,
									 infoPlist: infoPlist
		)
		return Project(name: name,
					   organizationName: "leka.io",
					   targets: targets)
	}

	/// Helper function to create the Project for this ExampleApp
	public static func module(name: String, platform: Platform, dependencies: [TargetDependency]) -> Project {
		let targets = makeFrameworkTargets(name: name,
										   platform: platform,
										   dependencies: dependencies)

		return Project(name: name,
					   organizationName: "leka.io",
					   targets: targets)
	}

	//
	// MARK: - Private
	//

	/// Helper function to create a framework target and an associated unit test target
	private static func makeFrameworkTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
		let sources = Target(name: name,
							 platform: platform,
							 product: .staticLibrary,
							 bundleId: "io.leka.apf.framework.\(name)",
							 deploymentTarget: .iOS(targetVersion: "16.0", devices: .ipad),
							 infoPlist: .default,
							 sources: ["Sources/**"],
							 resources: ["Resources/**"],
							 scripts: scripts,
							 dependencies: dependencies)

		let tests = Target(name: "\(name)Tests",
						   platform: platform,
						   product: .unitTests,
						   bundleId: "io.leka.apf.framework.\(name)Tests",
						   infoPlist: .default,
						   sources: ["Tests/**"],
						   resources: [],
						   scripts: scripts,
						   dependencies: [.target(name: name)])

		return [sources, tests]
	}

	/// Helper function to create the application target and the unit test target.
	private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency], infoPlist: [String: InfoPlist.Value] = [:]) -> [Target] {
		let platform: Platform = platform
		let base: [String: InfoPlist.Value] = [
			"CFBundleShortVersionString": "1.0",
			"CFBundleVersion": "1",
			"UIMainStoryboardFile": "",
			"UILaunchStoryboardName": "LaunchScreen"

		]

		let global = base.merging(infoPlist) { (_, new) in new }

		let mainTarget = Target(
			name: name,
			platform: platform,
			product: .app,
			bundleId: "io.leka.apf.app.\(name)",
			deploymentTarget: .iOS(targetVersion: "16.0", devices: .ipad),
			infoPlist: .extendingDefault(with: global),
			sources: ["Sources/**"],
			resources: ["Resources/**"],
			scripts: scripts,
			dependencies: dependencies
		)

		let testTarget = Target(
			name: "\(name)Tests",
			platform: platform,
			product: .unitTests,
			bundleId: "io.leka.apf.app.\(name)Tests",
			infoPlist: .default,
			sources: ["Tests/**"],
			resources: [],
			scripts: scripts,
			dependencies: [
				.target(name: "\(name)")
			])
		return [mainTarget, testTarget]
	}
}
