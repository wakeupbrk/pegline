import AppKit

/// Sits behind the line and accepts files dragged in from Finder.
/// The drag is always a copy: the original file never moves.
final class DropCatcher: NSView {
    let host: NSView
    var onDrop: ([URL]) -> Bool = { _ in false }
    /// While a file is being dragged over the line, this view takes the hit
    /// so the drop lands even on the empty rope or the menu-bar strip.
    var catching = false

    init(host: NSView) {
        self.host = host
        super.init(frame: .zero)
        autoresizingMask = [.width, .height]
        addSubview(host)
        registerForDraggedTypes([
            .fileURL,
            NSPasteboard.PasteboardType("NSFilenamesPboardType"),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    /// The line itself stays at the bottom. Extra height, used only while a
    /// drag is over the menu bar, is an invisible catcher above it.
    override func hitTest(_ point: NSPoint) -> NSView? {
        if catching { return bounds.contains(point) ? self : nil }
        return super.hitTest(point)
    }

    override func layout() {
        super.layout()
        host.frame = NSRect(x: 0, y: 0, width: bounds.width, height: min(Layout.panelHeight, bounds.height))
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation { operation(for: sender) }
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation { operation(for: sender) }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard operation(for: sender) == .copy else { return false }
        return onDrop(Self.fileURLs(from: sender.draggingPasteboard))
    }

    private func operation(for sender: NSDraggingInfo) -> NSDragOperation {
        guard !GrabView.isDragging, Self.hasFiles(sender.draggingPasteboard) else { return [] }
        return .copy
    }

    static func hasFiles(_ pasteboard: NSPasteboard) -> Bool {
        guard let types = pasteboard.types else { return false }
        return types.contains(.fileURL)
            || types.contains(NSPasteboard.PasteboardType("NSFilenamesPboardType"))
    }

    static func fileURLs(from pasteboard: NSPasteboard) -> [URL] {
        let options: [NSPasteboard.ReadingOptionKey: Any] = [.urlReadingFileURLsOnly: true]
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: options) as? [URL], !urls.isEmpty {
            return urls
        }
        let legacy = NSPasteboard.PasteboardType("NSFilenamesPboardType")
        let names = pasteboard.propertyList(forType: legacy) as? [String] ?? []
        return names.map { URL(fileURLWithPath: $0) }
    }
}
