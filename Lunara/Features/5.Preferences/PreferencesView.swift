//
//  PreferencesView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 18
    static let rowSpacing: CGFloat = 12
    static let rowHeight: CGFloat = 58
    static let groupSpacing: CGFloat = 18
}

struct PreferencesView: View {
    @AppStorage("displayName") private var displayName: String = ""
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    primaryGroup
                    secondaryGroup
                    aboutFooter
                }
                .padding(.horizontal, LunaraPadding.screen)
                .padding(.top, LunaraPadding.screen)
                .padding(.bottom, 110)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Preferences")
                    .font(.manropeBold(size: 18))
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension PreferencesView {
    var trimmedDisplayName: String {
        displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var profileSubtitle: String {
        trimmedDisplayName.isEmpty ? "Set your name" : trimmedDisplayName
    }

    var primaryGroup: some View {
        VStack(spacing: Constants.rowSpacing) {
            NavigationLink {
                ProfileView()
            } label: {
                PreferenceRowView(
                    title: "Profile",
                    subtitle: profileSubtitle,
                    iconSystemName: "person.crop.circle"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                AboutLunaraView()
            } label: {
                PreferenceRowView(
                    title: "About Lunara",
                    subtitle: "Learn more about the app",
                    iconSystemName: "sparkles"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                WhyDoWeDreamView()
            } label: {
                PreferenceRowView(
                    title: "Why do we dream?",
                    subtitle: "A simple look at dreaming",
                    iconSystemName: "moon.stars"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                PrivacyAndDataView()
            } label: {
                PreferenceRowView(
                    title: "Privacy / Your data",
                    subtitle: "How your entries are handled",
                    iconSystemName: "lock.shield"
                )
            }
            .buttonStyle(.plain)
            
            NavigationLink {
                CreditsView()
            } label: {
                PreferenceRowView(
                    title: "Credits",
                    subtitle: "Fonts, icons, and libraries used",
                    iconSystemName: "heart.text.square"
                )
            }
            .buttonStyle(.plain)
        }
    }

    var secondaryGroup: some View {
        VStack(spacing: Constants.rowSpacing) {
            Button {
                openSuggestions()
            } label: {
                PreferenceRowView(
                    title: "Suggestions",
                    subtitle: "Send feedback or ideas",
                    iconSystemName: "envelope"
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, Constants.groupSpacing)
    }

    var aboutFooter: some View {
        VStack(spacing: 6) {
            Text("Lunara")
                .font(LunaraFont.semiBoldSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))

            Text(appVersionText)
                .font(LunaraFont.lightExtraSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.6))
            
            Text("Created by Noumaan Mehmood")
                .font(LunaraFont.lightExtraSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
    }

    var appVersionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    func openSuggestions() {
        guard let url = URL(string: "mailto:lunara.dreams.app@gmail.com?subject=Lunara%20Suggestion") else { return }
        openURL(url)
    }
}

private struct PreferenceRowView: View {
    let title: String
    let subtitle: String
    let iconSystemName: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: iconSystemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(LunaraColor.pink)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream)

                Text(subtitle)
                    .font(LunaraFont.lightExtraSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.68))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(LunaraColor.cream.opacity(0.45))
        }
        .padding(.horizontal, 16)
        .frame(height: Constants.rowHeight)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.secondary.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }
}

#Preview {
    NavigationStack {
        PreferencesView()
    }
}
