import SwiftUI

struct BookmarkListView: View {
    @EnvironmentObject private var store: BookmarkStore

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        List {
            ForEach(store.bookmarks) { bookmark in
                VStack(alignment: .leading, spacing: 4) {
                    Text(bookmark.url.absoluteString)
                        .font(.body)
                        .lineLimit(2)
                    Text(Self.dateFormatter.string(from: bookmark.savedAt))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .onDelete { indexSet in
                Task {
                    for index in indexSet {
                        let bookmark = store.bookmarks[index]
                        try? await store.delete(bookmark)
                    }
                }
            }
        }
        .navigationTitle("Bookmarks")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add test URL") {
                    Task {
                        try? await store.save(url: URL(string: "https://example.com")!)
                    }
                }
            }
        }
        .task {
            try? await store.fetchAll()
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkListView()
            .environmentObject(BookmarkStore())
    }
}
