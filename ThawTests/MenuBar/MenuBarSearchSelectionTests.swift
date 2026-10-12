//
//  MenuBarSearchSelectionTests.swift
//  Project: Thaw
//
//  Copyright (Ice) © 2023–2025 Jordan Baird
//  Copyright (Thaw) © 2026 Toni Förster
//  Licensed under the GNU GPLv3

import SwiftUI
import Testing
@testable import Thaw

@Suite("Menu bar launcher selection")
@MainActor
struct MenuBarSearchSelectionTests {
    private typealias Item = SectionedListItem<MenuBarSearchModel.ItemID>
    private let first = MenuBarSearchModel.ItemID.item(.init(namespace: .null, title: "first"), windowID: 101)
    private let second = MenuBarSearchModel.ItemID.item(.init(namespace: .null, title: "second"), windowID: 102)

    private func row(_ id: MenuBarSearchModel.ItemID) -> Item {
        .item(id: id) { Text("Item") }
    }

    @Test("Removing the selected app selects the next available app")
    func removedSelection() {
        let model = MenuBarSearchModel()
        model.displayedItems = [row(first), row(second)]
        model.selection = first
        model.displayedItems = [.header(id: .header(.hidden)) { Text("Hidden") }, row(second)]
        #expect(model.selection == second)
    }

    @Test("A refresh preserves the selected app while it is still available")
    func preservedSelection() {
        let model = MenuBarSearchModel()
        model.displayedItems = [row(first), row(second)]
        model.selection = second
        model.displayedItems = [row(second), row(first)]
        #expect(model.selection == second)
    }

    @Test("No matching apps clears the selection even when section headers remain")
    func emptySelection() {
        let model = MenuBarSearchModel()
        model.displayedItems = [row(first)]
        model.selection = first
        model.displayedItems = [.header(id: .header(.hidden)) { Text("Hidden") }]
        #expect(model.selection == nil)
    }
}
