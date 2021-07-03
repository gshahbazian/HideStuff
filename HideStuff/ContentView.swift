import SwiftUI
import ApplicationsController
import UniformTypeIdentifiers

struct ContentView: View {
    var body: some View {
        VStack{
            BundleList()
            Button("Add Application") {
                let panel = NSOpenPanel()
                panel.allowedFileTypes = [UTType.application.identifier]
                panel.directoryURL = URL(fileURLWithPath: "/Applications")
                panel.begin { panelResponse in
                    guard panelResponse == NSApplication.ModalResponse.OK else { return }
                    guard let applicationUrl = panel.url else { return }

                    ApplicationsController.shared.bundleStore.blockApplication(at: applicationUrl.path)
                }
            }
            .padding(.bottom, 10)
        }
        .frame(minWidth: 300, minHeight: 300)
    }
}

struct BundleList: View {
    @ObservedObject var bundleStore = ApplicationsController.shared.bundleStore

    var body: some View {
        ZStack {
            List {
                ForEach(bundleStore.items) { item in
                    BundleListItem(bundle: item)
                }
            }
            Text("Add some apps to hide.")
                .font(.callout)
                .foregroundColor(Color.gray)
                .opacity(bundleStore.items.isEmpty ? 1 : 0)
        }
    }
}

struct BundleListItem: View {
    let bundle: BundleStore.BundleFile

    var body: some View {
        let appBundle = Bundle(path: bundle.filePath)
        let appName = appBundle?.infoDictionary?["CFBundleName"] as? String

        HStack {
            Image(nsImage: NSWorkspace.shared.icon(forFile: bundle.filePath))
            Text(appName ?? bundle.filePath)
                .foregroundColor(appBundle == nil ? .red : .black)
                .lineLimit(1)
            Spacer()
            Button("Remove") {
                ApplicationsController.shared.bundleStore.removeBlockedApplication(bunlde: bundle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
