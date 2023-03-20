import ProjectDescription

let workspace = Workspace(
	name: "ios-monorepo",
	projects: [
		// MARK: - Apps
		"Apps/LekaApp",
		"Apps/LekaEmotions",
		"Apps/LekaUpdater",
		"Apps/LekaBLE",

		// MARK: - Modules
		"Modules/CoreUI",
	]
)
