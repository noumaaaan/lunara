//
//  CreditsView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 16/04/2026.
//

import Foundation
import SwiftUI

private enum Constants {
    static let sectionSpacing: CGFloat = 18
    static let cardPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 100
}

struct CreditsView: View {
    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    headerSection
                    
                    creditsCard(
                        title: "HorizonCalendar",
                        body: "The calendar is powered by HorizonCalendar from Airbnb, making it smooth and delightful to browse dream entries by date.",
                        link: "https://github.com/airbnb/HorizonCalendar",
                        linkText: "View on GitHub"
                    )
                    
                    creditsCard(
                        title: "Google Fonts & Material Icons",
                        body: "Lunara uses Google Fonts for its beautiful and consistent typography. Some icons are based on Material Icons, helping keep the interface clean, clear, and expressive.",
                        link: "https://fonts.google.com/icons",
                        linkText: "View Icons"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, LunaraPadding.screen)
                .padding(.top, LunaraPadding.screen)
                .padding(.bottom, Constants.bottomPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(LunaraColor.tabBar, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Credits")
                    .font(LunaraFont.bold)
                    .foregroundStyle(LunaraColor.cream)
            }
        }
    }
}

private extension CreditsView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(LunaraColor.pink)

                Text("CREDITS")
                    .font(LunaraFont.lightExtraSmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.72))
                    .textCase(.uppercase)
            }

            Text("Made with love and open source")
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)

            Text("Lunara was built with care using beautiful tools and libraries from the open source community. A heartfelt thank you to everyone who creates and maintains them.")
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                .fill(LunaraColor.tertiary.opacity(0.5))
                .overlay {
                    RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                        .stroke(LunaraColor.border, lineWidth: 1)
                }
        )
    }

    func creditsCard(title: String, body: String, link: String? = nil, linkText: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)
            
            Text(body)
                .font(LunaraFont.body)
                .foregroundStyle(LunaraColor.cream.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            
            // Add the link if provided
            if let link = link, let linkText = linkText {
                Link(destination: URL(string: link)!) {
                    HStack(spacing: 6) {
                        Text(linkText)
                            .font(LunaraFont.body)
                            .foregroundStyle(LunaraColor.pink)   // or LunaraColor.accent if you have one
                        
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(LunaraColor.pink)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.cardPadding)
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
        CreditsView()
    }
}
