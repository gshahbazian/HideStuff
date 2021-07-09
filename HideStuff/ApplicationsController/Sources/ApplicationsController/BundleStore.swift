import Foundation

public class BundleStore: ObservableObject {

    public struct BundleFile: Identifiable, Equatable, Codable {
        public let filePath: String
        public let bundleIdentifier: String

        public init(filePath: String, bundleIdentifier: String) {
            self.filePath = filePath
            self.bundleIdentifier = bundleIdentifier
        }

        public var id: String {
            filePath
        }
    }

    @Published public private(set) var items: [BundleFile] {
        didSet {
            let json = JSONEncoder()
            UserDefaults.standard.setValue(items.compactMap { try? json.encode($0) }, forKey: "items")
        }
    }

    init() {
        let userData: [Data] = UserDefaults.standard.array(forKey: "items") as? [Data] ?? []
        let json = JSONDecoder()
        items = userData.compactMap { try? json.decode(BundleFile.self, from: $0) }
    }

    public func blockApplication(at path: String) {
        guard let bundleIdentifier = Bundle(path: path)?.bundleIdentifier else { return }
        let insertingBundle = BundleFile(filePath: path, bundleIdentifier: bundleIdentifier)
        if items.contains(insertingBundle) { return }

        items.append(insertingBundle)
    }

    public func removeBlockedApplication(bunlde: BundleFile) {
        items.removeAll(where: { $0 == bunlde })
    }
}
