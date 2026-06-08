import CloudKit
import Foundation

// MARK: - Protocol

protocol BookmarkStoring {
    var bookmarks: [Bookmark] { get }
    func save(url: URL) async throws
    func delete(_ bookmark: Bookmark) async throws
    func fetchAll() async throws
}

// MARK: - Real Store

@MainActor
final class BookmarkStore: ObservableObject, BookmarkStoring {
    @Published private(set) var bookmarks: [Bookmark] = []

    private var database: CKDatabase {
        CKContainer(identifier: "iCloud.dev.eythorsson.share").privateCloudDatabase
    }

    private let recordType = "Bookmark"

    func save(url: URL) async throws {
        let record = CKRecord(recordType: recordType)
        record["url"] = url.absoluteString as CKRecordValue
        let savedRecord = try await database.save(record)
        guard let bookmark = Bookmark(record: savedRecord) else {
            throw BookmarkStoreError.invalidRecord
        }
        bookmarks.insert(bookmark, at: 0)
    }

    func delete(_ bookmark: Bookmark) async throws {
        try await database.deleteRecord(withID: bookmark.id)
        bookmarks.removeAll { $0.id == bookmark.id }
    }

    func fetchAll() async throws {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = try await database.records(matching: query)
        bookmarks = result.matchResults.compactMap { _, outcome in
            guard let record = try? outcome.get() else { return nil }
            return Bookmark(record: record)
        }
    }
}

// MARK: - Errors

enum BookmarkStoreError: Error {
    case invalidRecord
}
