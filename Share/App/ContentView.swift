import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            BookmarkListView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BookmarkStore())
}
