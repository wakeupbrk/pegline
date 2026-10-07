// Draws the Pegline app icon: a navy tile, one cord, one peg.
// Usage: swift scripts/make-icon.swift out.png
import AppKit

let size: CGFloat = 1024
let out = CommandLine.arguments.dropFirst().first ?? "icon.png"

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size),
                           bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                           colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let ctx = NSGraphicsContext.current!.cgContext

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> NSColor {
    NSColor(srgbRed: r / 255, green: g / 255, blue: b / 255, alpha: a)
}

let body = NSRect(x: 96, y: 96, width: 832, height: 832)
let tile = NSBezierPath(roundedRect: body, xRadius: 186, yRadius: 186)
color(18, 52, 48).setFill()
tile.fill()

let cord = NSBezierPath()
cord.move(to: NSPoint(x: 180, y: 560))
cord.line(to: NSPoint(x: 844, y: 560))
cord.lineWidth = 28
cord.lineCapStyle = .round
color(232, 220, 196).setStroke()
cord.stroke()

let peg = NSBezierPath(roundedRect: NSRect(x: 456, y: 470, width: 112, height: 250), xRadius: 36, yRadius: 36)
color(214, 122, 46).setFill()
peg.fill()
let slot = NSBezierPath(roundedRect: NSRect(x: 490, y: 575, width: 44, height: 14), xRadius: 6, yRadius: 6)
color(18, 52, 48).setFill()
slot.fill()

ctx.flush()
NSGraphicsContext.restoreGraphicsState()

guard let data = rep.representation(using: .png, properties: [:]) else {
    fputs("Could not encode icon\n", stderr)
    exit(1)
}
try data.write(to: URL(fileURLWithPath: out))
