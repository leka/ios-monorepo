import SwiftUI

@main
struct LekaActivityUIExplorerApp: App {

    @StateObject var navigator = NavigationManager()
    @StateObject var gameEngine = GameEngine()
    @StateObject var defaults = GLT_Defaults()
    @StateObject var configuration = GLT_Configurations()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(navigator)
                .environmentObject(gameEngine)
                .environmentObject(defaults)
                .environmentObject(configuration)
                .onAppear {
                    gameEngine.bufferActivity = EmptyDataSets().makeEmptyActivity()
                    configuration.editorIsEmpty = true

                    // For now, because just an explorer
                    configuration.disableEditor = true
                }
        }
    }
}
