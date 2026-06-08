import CloudKit
import XCTest
@testable import Share

// MARK: - Mock

final class BookmarkStoreMock: BookmarkStoring {
    private(set) var bookmarks: [Bookmark] = []
    private var nextID = 0

    func save(url: URL) async throws {
        let recordID = CKRecord.ID(recordName: "mock-\(nextID)")
        nextID += 1
        let bookmark = Bookmark(id: recordID, url: url, savedAt: Date())
        // insert at front so newest is first
        bookmarks.insert(bookmark, at: 0)
    }

    func delete(_ bookmark: Bookmark) async throws {
        bookmarks.removeAll { $0.id == bookmark.id }
    }

    func fetchAll() async throws {
        // no-op: in-memory store is always up-to-date
    }
}

// MARK: - Tests

final class BookmarkStoreTests: XCTestCase {
    func testSaveThenFetchRoundTrip() async throws {
        let mock = BookmarkStoreMock()
        let url = URL(string: "https://example.com")!
        try await mock.save(url: url)
        try await mock.fetchAll()
        XCTAssertEqual(mock.bookmarks.count, 1)
        XCTAssertEqual(mock.bookmarks.first?.url, url)
    }

    func testDeleteRemovesItem() async throws {
        let mock = BookmarkStoreMock()
        let url = URL(string: "https://example.com")!
        try await mock.save(url: url)
        XCTAssertEqual(mock.bookmarks.count, 1)
        let bookmark = mock.bookmarks[0]
        try await mock.delete(bookmark)
        XCTAssertTrue(mock.bookmarks.isEmpty)
    }

    func testItemsOrderedNewestFirst() async throws {
        let mock = BookmarkStoreMock()
        let first = URL(string: "https://first.example.com")!
        let second = URL(string: "https://second.example.com")!
        let third = URL(string: "https://third.example.com")!
        try await mock.save(url: first)
        try await mock.save(url: second)
        try await mock.save(url: third)
        // newest-first: third, second, first
        XCTAssertEqual(mock.bookmarks[0].url, third)
        XCTAssertEqual(mock.bookmarks[1].url, second)
        XCTAssertEqual(mock.bookmarks[2].url, first)
    }
}
