// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Darwin
import Foundation
import Logging

// ? Note: taken from https://github.com/apple/swift-log/blob/main/Sources/Logging/Logging.swift

// swiftlint:disable function_parameter_count

extension String {
    var fileURL: URL {
        URL(fileURLWithPath: self)
    }

    var pathExtension: String {
        fileURL.pathExtension
    }

    var lastPathComponent: String {
        fileURL.lastPathComponent
    }
}

let systemStderr = Darwin.stderr
let systemStdout = Darwin.stdout

typealias CFilePointer = UnsafeMutablePointer<FILE>

// MARK: - StdioOutputStream

struct StdioOutputStream: TextOutputStream {
    enum FlushMode {
        case undefined
        case always
    }

    static let stderr = StdioOutputStream(file: systemStderr, flushMode: .always)
    static let stdout = StdioOutputStream(file: systemStdout, flushMode: .always)

    let file: CFilePointer
    let flushMode: FlushMode

    func write(_ string: String) {
        contiguousUTF8(string)
            .withContiguousStorageIfAvailable { utf8Bytes in
                flockfile(file)
                defer {
                    funlockfile(self.file)
                }
                _ = fwrite(utf8Bytes.baseAddress!, 1, utf8Bytes.count, file)
                if case .always = flushMode {
                    flush()
                }
            }!
    }

    func flush() {
        _ = fflush(file)
    }

    func contiguousUTF8(_ string: String) -> String.UTF8View {
        var contiguousString = string
        contiguousString.makeContiguousUTF8()
        return contiguousString.utf8
    }
}

// MARK: - LogKitLogHandler

public struct LogKitLogHandler: LogHandler {
    // MARK: Lifecycle

    // internal for testing only
    init(label: String, stream: _SendableTextOutputStream) {
        self.init(label: label, stream: stream, metadataProvider: LoggingSystem.metadataProvider)
    }

    // internal for testing only
    init(label: String, stream: _SendableTextOutputStream, metadataProvider: Logger.MetadataProvider?) {
        self.label = label
        self.stream = stream
        self.metadataProvider = metadataProvider
    }

    // MARK: Public

    public var logLevel: Logger.Level = .trace

    public var metadataProvider: Logger.MetadataProvider?

    public var metadata = Logger.Metadata()

    /// Factory that makes a `LogKitLogHandler` to directs its output to `stdout`
    public static func standardOutput(label: String) -> LogKitLogHandler {
        LogKitLogHandler(
            label: label, stream: StdioOutputStream.stdout, metadataProvider: LoggingSystem.metadataProvider)
    }

    /// Factory that makes a `LogKitLogHandler` that directs its output to `stdout`
    public static func standardOutput(label: String, metadataProvider: Logger.MetadataProvider?) -> LogKitLogHandler {
        LogKitLogHandler(label: label, stream: StdioOutputStream.stdout, metadataProvider: metadataProvider)
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set {
            metadata[metadataKey] = newValue
        }
    }

    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata _: Logger.Metadata?,
        source _: String,
        file: String,
        function: String,
        line: UInt
    ) {
        var strm = stream

        strm.write(
            "\(timestamp()) \(prettyLevel(level)) [\(label)](\(prettyFile(file)):\(line)) \(function) > \(message)\n"
        )
    }

    // MARK: Internal

    typealias _SendableTextOutputStream = TextOutputStream & Sendable

    // MARK: Private

    private let stream: _SendableTextOutputStream
    private let label: String

    private var prettyMetadata: String?

    private func prettyLevel(_ level: Logger.Level) -> String {
        switch level {
            case .trace:
                "🩶 [TRCE]"
            case .debug:
                "💚 [DBUG]"
            case .info, .notice:
                "💙 [INFO]"
            case .warning:
                "⚠️ [WARN]"
            case .error:
                "❌ [ERR ]"
            case .critical:
                "💥 [CRIT]"
        }
    }

    private func prettyFile(_ file: String) -> String {
        file.lastPathComponent
    }

    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        let milliseconds = Int(Date().timeIntervalSince1970 * 1000) % 1000

        strftime(&buffer, buffer.count, "%H:%M:%S%", localTime)

        buffer.replaceSubrange(8..<12, with: String(format: ".%03d", milliseconds).utf8CString)

        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}

// swiftlint:enable function_parameter_count
