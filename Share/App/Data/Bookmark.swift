import CloudKit
import Foundation

struct Bookmark: Identifiable, Equatable {
    let id: CKRecord.ID
    let url: URL
    let savedAt: Date

    init(id: CKRecord.ID, url: URL, savedAt: Date) {
        self.id = id
        self.url = url
        self.savedAt = savedAt
    }

    init?(record: CKRecord) {
        guard
            let urlString = record["url"] as? String,
            let url = URL(string: urlString)
        else { return nil }
        self.id = record.recordID
        self.url = url
        self.savedAt = record.creationDate ?? Date()
    }
}
