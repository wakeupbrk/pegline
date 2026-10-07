import AppKit

/// Temporary copies of files dragged onto the line.
///
/// The original stays where it was. The card hangs the copy, and discarding
/// the card deletes that copy.
enum Clips {
    static let folder: URL = {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("Tendedero/Hanging", isDirectory: true)
    }()

    /// A real file, with aliases and symlinks resolved. Folders are refused:
    /// a temporary copy of a folder could be enormous.
    static func regularFile(at url: URL) -> URL? {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        let resolved = (try? URL(resolvingAliasFileAt: url, options: [.withoutMounting]))
            ?? url.resolvingSymlinksInPath()
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: resolved.path, isDirectory: &isDir),
              !isDir.boolValue else { return nil }
        return resolved
    }

    static func byteSize(_ url: URL) -> Int {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        return (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
    }

    static func copies(of files: [URL]) -> [URL] {
        files.compactMap { file in
            do {
                return try copy(file)
            } catch {
                log.error("Could not copy \(file.lastPathComponent, privacy: .public): \(error.localizedDescription, privacy: .public)")
                return nil
            }
        }
    }

    static func copy(_ url: URL) throws -> URL {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let target = uniqueURL(in: folder, named: url.lastPathComponent)
        try FileManager.default.copyItem(at: url, to: target)
        return target
    }

    /// What a non-image file looks like on the line: its icon, and its name.
    static func iconCard(for url: URL) -> NSImage {
        let size = NSSize(width: 320, height: 220)
        let image = NSImage(size: size)
        image.lockFocus()

        let iconSide: CGFloat = 96
        let icon = NSWorkspace.shared.icon(forFile: url.path)
        icon.draw(in: NSRect(x: (size.width - iconSide) / 2, y: 84, width: iconSide, height: iconSide))

        let name = url.lastPathComponent as NSString
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineBreakMode = .byTruncatingMiddle
        let text = NSAttributedString(string: name as String, attributes: [
            .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: NSColor.black.withAlphaComponent(0.82),
            .paragraphStyle: paragraph,
        ])
        let textSize = text.boundingRect(
            with: NSSize(width: size.width - 48, height: 28),
            options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
        ).size
        let capsule = NSRect(
            x: (size.width - textSize.width - 28) / 2,
            y: 30,
            width: min(size.width - 24, textSize.width + 28),
            height: 32
        )
        NSColor.white.withAlphaComponent(0.9).setFill()
        NSBezierPath(roundedRect: capsule, xRadius: 12, yRadius: 12).fill()
        text.draw(in: capsule.insetBy(dx: 12, dy: 6))

        image.unlockFocus()
        return image
    }

    private static func uniqueURL(in folder: URL, named name: String) -> URL {
        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        func named(_ n: Int) -> URL {
            let stem = n == 1 ? (base.isEmpty ? name : base) : "\(base) \(n)"
            if ext.isEmpty { return folder.appendingPathComponent(stem) }
            return folder.appendingPathComponent(stem).appendingPathExtension(ext)
        }
        var n = 1
        var candidate = named(1)
        while FileManager.default.fileExists(atPath: candidate.path) {
            n += 1
            candidate = named(n)
        }
        return candidate
    }
}
