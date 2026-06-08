#if canImport(UIKit)
import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedURL()
    }

    private func handleSharedURL() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier) { [weak self] item, error in
                guard let self else { return }
                if let url = item as? URL {
                    self.save(url: url)
                } else {
                    self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                }
            }
        } else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }

    private func save(url: URL) {
        // TODO: Save URL to shared App Group container in a later issue
        print("[ShareExtension] Received URL: \(url)")
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
#endif
