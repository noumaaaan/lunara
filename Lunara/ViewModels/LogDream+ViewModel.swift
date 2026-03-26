//
//  LogDream+ViewModel.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import Combine
import SwiftData

final class LogDreamViewModel: ObservableObject {
    @Published var dreamDate: Date
    @Published var title: String
    @Published var content: String
    @Published var selectedCategory: DreamCategory
    @Published var selectedIntensity: Int
    @Published var selectedMood: WakingMood

    init(
        dreamDate: Date = Date(),
        title: String = "",
        content: String = "",
        selectedCategory: DreamCategory = .normal,
        selectedIntensity: Int = 2,
        selectedMood: WakingMood = .neutral
    ) {
        self.dreamDate = dreamDate
        self.title = title
        self.content = content
        self.selectedCategory = selectedCategory
        self.selectedIntensity = selectedIntensity
        self.selectedMood = selectedMood
    }

    convenience init(entry: DreamEntry) {
        self.init(
            dreamDate: entry.dreamDate,
            title: entry.title,
            content: entry.content,
            selectedCategory: entry.category,
            selectedIntensity: entry.intensity,
            selectedMood: entry.wakingMood
        )
    }

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedContent: String {
        content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSaveDisabled: Bool {
        trimmedContent.isEmpty
    }

    var currentIntensity: DreamIntensity {
        DreamIntensity(rawValue: selectedIntensity) ?? .notSoIntense
    }

    @discardableResult
    func saveDream(using modelContext: ModelContext) throws -> DreamEntry {
        let entry = DreamEntry(
            created: Date(),
            modified: Date(),
            dreamDate: dreamDate,
            title: trimmedTitle,
            content: trimmedContent,
            category: selectedCategory,
            intensity: selectedIntensity,
            wakingMood: selectedMood
        )

        modelContext.insert(entry)
        try modelContext.save()
        reset()

        return entry
    }

    func updateDream(_ entry: DreamEntry, using modelContext: ModelContext) throws {
        entry.dreamDate = dreamDate
        entry.title = trimmedTitle
        entry.content = trimmedContent
        entry.category = selectedCategory
        entry.intensity = selectedIntensity
        entry.wakingMood = selectedMood
        entry.modified = Date()

        try modelContext.save()
    }

    func reset() {
        dreamDate = Date()
        title = ""
        content = ""
        selectedCategory = .normal
        selectedIntensity = 2
        selectedMood = .neutral
    }
}
