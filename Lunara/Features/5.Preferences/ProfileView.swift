//
//  ProfileView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation
import SwiftUI

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let titleFieldHeight: CGFloat = 50
}

struct ProfileView: View {
    @AppStorage("displayName") private var displayName: String = ""
    @FocusState private var isNameFocused: Bool

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                Text("Your name")
                    .font(LunaraFont.semiBold)
                    .foregroundStyle(LunaraColor.cream)

                Text("This helps make Lunara feel a little more personal.")
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.75))

                CustomTextField(
                    text: $displayName,
                    placeholder: "Enter your name",
                    height: Constants.titleFieldHeight,
                    isFocused: $isNameFocused
                )

                Spacer()
            }
            .padding(.horizontal, LunaraPadding.screen)
            .padding(.top, LunaraPadding.screen)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profile")
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isNameFocused = false
                }
                .font(LunaraFont.body)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
