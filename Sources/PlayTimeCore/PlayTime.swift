import Foundation

public final class PlayTime {
    private enum Platform: String {
        case ios, osx

        init(arguments: [String]) {
            self = arguments.contains("osx") ? .osx : .ios
        }

        var contentsXcPlayground: String {
            return CONTENTS_XCPLAYGROUND_TEMPLATE.replacingOccurrences(of: "#{PLATFORM}", with: rawValue)
        }

        var contentsSwift: String {
            return IMPORT_TEMPLATE.replacingOccurrences(of: "#{FRAMEWORK}", with: framework)
        }

        private var framework: String {
            switch self {
            case .ios:
                return "UIKit"
            case .osx:
                return "Cocoa"
            }
        }
    }

    private let platform: Platform

    private var playgroundPath: String {
        let now = Date()
        return TMP_PATH_TEMPLATE.replacingOccurrences(of: "#{PLAYGROUND_FILE_NAME}", with: formatter.string(from: now))
    }

    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }

    public init(arguments: [String] = CommandLine.arguments) {
        self.platform = Platform(arguments: arguments)
    }

    public func run() throws {
        do {
            try FileManager.default.createDirectory(atPath: playgroundPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            fatalError("Unable to create the playground directory. Error: \(error)")
        }

        let tmpUrl = URL(fileURLWithPath: playgroundPath, isDirectory: true)

        let contentsXcPlaygrounFilePath = tmpUrl
            .appendingPathComponent(CONTENTS_XCPLAYGROUND_FILENAME)

        do {
            try platform.contentsXcPlayground.write(to: contentsXcPlaygrounFilePath, atomically: false, encoding: .utf8)
        } catch let error {
            fatalError("Unable to write to the xcplayground file. Error: \(error)")
        }

        let contentsSwiftFilePath = tmpUrl
            .appendingPathComponent(CONTENTS_SWIFT_FILENAME)

        do {
            try platform.contentsSwift.write(to: contentsSwiftFilePath, atomically: false, encoding: .utf8)
        } catch let error {
            fatalError("Unable to write to the xcplayground file. Error: \(error)")
        }

        shell("open", playgroundPath)
    }

    @discardableResult
    private func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
