// The MIT License (MIT)
//
// Copyright (c) 2020-2026 Alexander Grebenyuk (github.com/kean).

import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS)

@available(iOS 18, tvOS 18, macOS 15, watchOS 11, visionOS 1, *)
struct ConsoleNavigationTitleView: View {
    @EnvironmentObject private var environment: ConsoleEnvironment
    @EnvironmentObject private var listViewModel: ConsoleListViewModel
    @EnvironmentObject private var searchViewModel: ConsoleSearchViewModel

    var body: some View {
        Menu {
            modeButton(.all, title: "All")
            modeButton(.logs, title: "Logs")
            modeButton(.network, title: "Network")

            // A section of their own: these narrow the network list rather
            // than choosing what kind of list it is, and running them together
            // with the built-in three would read as four alternatives when
            // they are not.
            if !environment.customModes.isEmpty {
                Section {
                    ForEach(environment.customModes) { customMode in
                        customModeButton(customMode)
                    }
                }
            }
        } label: {
            headerView
        }
    }

    @ViewBuilder
    private var headerView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            VStack(alignment: .center, spacing: 0) {
                Text(modeTitle)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Image(systemName: "chevron.down.circle.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary, Color(.tertiarySystemFill))
                .offset(y: -1)
        }
    }

    private func modeButton(_ mode: ConsoleMode, title: String) -> some View {
        Button {
            // Clears any custom mode: picking one of the three built-in views
            // is how a reader gets back to the unnarrowed list.
            environment.select(nil)
            environment.mode = mode
        } label: {
            if environment.customMode == nil, environment.mode == mode {
                Label(title, systemImage: "checkmark")
            } else {
                Text(title)
            }
        }
    }

    private func customModeButton(_ customMode: ConsoleCustomMode) -> some View {
        Button {
            environment.select(customMode)
        } label: {
            if environment.customMode?.id == customMode.id {
                Label(customMode.title, systemImage: "checkmark")
            } else {
                Text(customMode.title)
            }
        }
    }

    private var modeTitle: String {
        if let customMode = environment.customMode {
            return customMode.title
        }
        switch environment.mode {
        case .all: return "Console"
        case .logs: return "Logs"
        case .network: return "Network"
        }
    }

    private var subtitle: String {
        let total = environment.mode.formattedCount(listViewModel.entities.count)
        if searchViewModel.isSearching, searchViewModel.searchBar.text.isEmpty == false {
            return "\(searchViewModel.results.count)\(searchViewModel.hasMore ? "+" : "") / \(total)"
        }
        return total
    }
}

#endif
