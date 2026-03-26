//
//  KeyboardObserver.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import Foundation
import SwiftUI
import Combine

final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .merge(
                with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false }
            )
            .receive(on: RunLoop.main)
            .assign(to: &$isKeyboardVisible)
    }
}
