import SwiftUI

@main
struct ShareApp: App {
    @StateObject private var store = BookmarkStore()

    private var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    var body: some Scene {
        WindowGroup {
            if isRunningTests {
                EmptyView()
            } else {
                ContentView()
                    .environmentObject(store)
            }
        }
    }
}
