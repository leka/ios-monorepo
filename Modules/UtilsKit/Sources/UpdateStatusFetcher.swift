// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// AppUpdate folder is heavily inspired by:
// https://github.com/AvdLee/AppUpdately
// AvdLee/AppUpdately License: MIT

import Combine
import Foundation

// MARK: - AppMetadata

struct AppMetadata: Codable {
    let trackViewURL: URL
    let version: String
    let minimumOsVersion: String
}

// MARK: - AppMetadataResults

struct AppMetadataResults: Codable {
    let results: [AppMetadata]
}

// MARK: - UpdateStatusFetcher

public struct UpdateStatusFetcher {
    // MARK: Lifecycle

    public init(bundleIdentifier: String = Bundle.main.bundleIdentifier!, urlSession: URLSession = .shared) {
        self.url = URL(string: self.prefixURL + "\(bundleIdentifier)")!
        self.bundleIdentifier = bundleIdentifier
        self.urlSession = urlSession
    }

    // MARK: Public

    public enum Status: Equatable {
        case newerVersion
        case upToDate
        case updateAvailable(version: String, storeURL: URL)
        case underMinimumOsVersion
    }

    public enum FetchError: LocalizedError {
        case metadata
        case bundleShortVersion

        // MARK: Public

        public var errorDescription: String? {
            switch self {
                case .metadata:
                    "Metadata could not be found"
                case .bundleShortVersion:
                    "Bundle short version could not be found"
            }
        }
    }

    public func fetch(_ completion: @escaping (Swift.Result<Status, Error>) -> Void) -> AnyCancellable {
        self.urlSession
            .dataTaskPublisher(for: self.url)
            .map(\.data)
            .decode(type: AppMetadataResults.self, decoder: self.decoder)
            .tryMap { metadataResults -> Status in
                guard let appMetadata = metadataResults.results.first else {
                    throw FetchError.metadata
                }
                return try self.updateStatus(for: appMetadata)
            }
            .sink { completionStatus in
                switch completionStatus {
                    case let .failure(error):
                        completion(.failure(error))
                    case .finished:
                        break
                }
            } receiveValue: { status in
                completion(.success(status))
            }
    }

    // MARK: Internal

    let url: URL
    var currentVersionProvider: () -> String? = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    // MARK: Private

    private let prefixURL = "https://itunes.apple.com/lookup?bundleId="
    private let bundleIdentifier: String
    private let decoder: JSONDecoder = .init()
    private let urlSession: URLSession

    private func updateStatus(for appMetadata: AppMetadata) throws -> Status {
        guard let currentVersion = currentVersionProvider() else {
            throw UpdateStatusFetcher.FetchError.bundleShortVersion
        }

        // Get the device's current iOS version
        let deviceOSVersion = ProcessInfo.processInfo.operatingSystemVersion
        let deviceOSString = "\(deviceOSVersion.majorVersion).\(deviceOSVersion.minorVersion).\(deviceOSVersion.patchVersion)"

        // Compare the required iOS version with the device's current version
        if deviceOSString.compare(appMetadata.minimumOsVersion, options: .numeric) == .orderedAscending {
            return UpdateStatusFetcher.Status.underMinimumOsVersion
        }

        switch currentVersion.compare(appMetadata.version) {
            case .orderedDescending:
                return UpdateStatusFetcher.Status.newerVersion
            case .orderedSame:
                return UpdateStatusFetcher.Status.upToDate
            case .orderedAscending:
                return UpdateStatusFetcher.Status.updateAvailable(version: appMetadata.version, storeURL: appMetadata.trackViewURL)
        }
    }
}
