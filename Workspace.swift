import ProjectDescription

let workspace = Workspace(
	name: "ios-monorepo",
	projects: [
		// MARK: - Apps
		"Apps/LekaApp",
		"Apps/LekaCombineCB",
		"Apps/LekaEmotions",
		"Apps/LekaUpdater",

        // MARK: - Modules
        "Modules/CoreUI",
    ]
)
