import ProjectDescription

let workspace = Workspace(
	name: "ios-monorepo",
	projects: [
		// MARK: - Apps
		"Apps/LekaApp",
		"Apps/BLEKitExample",
		"Apps/LekaEmotions",
		"Apps/LekaUpdater",

		// MARK: - Modules
		"Modules/CoreUI",
		"Modules/BLEKit",
	]
)
