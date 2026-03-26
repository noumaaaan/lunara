//
//  AppRouter.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI
import Combine

final class AppRouter: ObservableObject {
    @Published var selectedTab: TabOption = .log
    @Published var toastMessage: String?
    @Published var pendingJournalEntryID: UUID?

    func handleDreamSaved(_ entryID: UUID) {
        pendingJournalEntryID = entryID
        toastMessage = "Dream saved"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.toastMessage = nil
            self?.selectedTab = .journal
        }
    }

    func handleDreamDeleted() {
        toastMessage = "Dream deleted"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.toastMessage = nil
        }
    }
}
