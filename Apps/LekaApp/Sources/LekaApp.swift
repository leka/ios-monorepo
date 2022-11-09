import SwiftUI
import CoreUI
import CoreLogger

@main
struct LekaApp: App {
	public init () {
		CoreLogger.set(module: "LekaApp")
		Log.info("Hello from LekaApp")
	}
    var body: some Scene {
        WindowGroup {
			Hello("Leka App", in: .green)
            Image(uiImage: CoreUIAsset.Assets.lekaLogo.image)
        }
    }
}
