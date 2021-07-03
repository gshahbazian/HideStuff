import Cocoa

public class ApplicationsController {

    public static let shared = ApplicationsController()

    public let bundleStore = BundleStore()

    init() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: nil) { _ in
            self.hideAppsIfNeeded()
        }

        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didDeactivateApplicationNotification, object: nil, queue: nil) { _ in
            self.hideAppsIfNeeded()
        }

        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didUnhideApplicationNotification, object: nil, queue: nil) { _ in
            self.hideAppsIfNeeded()
        }
    }

    func hideAppsIfNeeded() {
        let apps = NSWorkspace.shared.runningApplications
        let visibleBackgroundApps = apps
            .filter { !$0.isHidden && !$0.isActive }

        let blockedBundleIdentificers = Set(bundleStore.items.map { $0.bundleIdentifier })

        for app in visibleBackgroundApps {
            guard let bundleIdentifier = app.bundleIdentifier else { continue }
            if blockedBundleIdentificers.contains(bundleIdentifier) {
                app.hide()
            }
        }
    }
}
