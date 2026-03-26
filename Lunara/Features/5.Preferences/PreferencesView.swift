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
                    sectionTitle("Preferences")

                    VStack(spacing: Constants.rowSpacing) {
                        NavigationLink {
                            ProfileView()
                        } label: {
                            PreferenceRowView(
                                title: "Profile",
                                subtitle: displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Set your name" : displayName,
                                iconSystemName: "person.crop.circle"
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            AboutLunaraView()
                        } label: {
                            PreferenceRowView(
                                title: "About Lunara",
                                subtitle: "What the app is about",
                                iconSystemName: "sparkles"
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            WhyDoWeDreamView()
                        } label: {
                            PreferenceRowView(
                                title: "Why do we dream?",
                                subtitle: "A simple explanation",
                                iconSystemName: "moon.stars"
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            PrivacyAndDataView()
                        } label: {
                            PreferenceRowView(
                                title: "Privacy / Your data",
                                subtitle: "How Lunara handles your entries",
                                iconSystemName: "lock.shield"
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            openBuyMeACoffee()
                        } label: {
                            PreferenceRowView(
                                title: "Buy Me a Coffee",
                                subtitle: "Support Lunara",
                                iconSystemName: "cup.and.saucer"
                            )
                        }
                        .buttonStyle(.plain)

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
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension PreferencesView {
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(LunaraFont.semiBold)
            .foregroundStyle(LunaraColor.cream)
    }

    var aboutFooter: some View {
        VStack(spacing: 6) {
            Text("Lunara")
                .font(LunaraFont.semiBoldSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))

            Text(appVersionText)
                .font(LunaraFont.lightExtraSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    var appVersionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    func openBuyMeACoffee() {
        guard let url = URL(string: "https://buymeacoffee.com/YOUR_LINK") else { return }
        openURL(url)
    }

    func openSuggestions() {
        guard let url = URL(string: "mailto:you@example.com?subject=Lunara%20Suggestion") else { return }
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
