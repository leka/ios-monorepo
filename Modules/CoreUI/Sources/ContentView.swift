import SwiftUI

import CoreLogger

public struct Hello: View {

	let name: String
	let color: Color

	public init(_ name: String, in color: Color) {
		self.name = name
		self.color = color

		CoreLogger.set(module: "CoreUI")

		Log.info("Hello, \(name) in \(color)")

	}

    public var body: some View {
		VStack {
			Text("Hello, \(name)!")
				.padding(50)
				.background(color)

			Image(uiImage: CoreUIAsset.Assets.lekaLogo.image)
				.resizable()
				.scaledToFit()
				.frame(width: 200.0)
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Hello("World", in: .pink)
    }
}
