//
//  CategorySelectionView.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let itemHeight: CGFloat = 50
    static let horizontalPadding: CGFloat = 16
    static let gridSpacing: CGFloat = 8
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: DreamCategory

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: Constants.gridSpacing),
        count: 6
    )

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            headerSection

            LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
                ForEach(DreamCategory.allCases, id: \.self) { category in
                    categoryButton(for: category)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

private extension CategorySelectionView {
    var headerSection: some View {
        HStack(spacing: .zero) {
            Text("Dream Category")
                .font(LunaraFont.lightSmall)
                .foregroundStyle(LunaraColor.cream.opacity(0.9))

            Spacer()

            Text(selectedCategory.displayName)
                .font(LunaraFont.semiBold)
                .foregroundStyle(LunaraColor.cream)
                .contentTransition(.opacity)
                .animation(.easeInOut(duration: 0.18), value: selectedCategory)
        }
        .padding(.bottom, 10)
    }

    @ViewBuilder
    func categoryButton(for category: DreamCategory) -> some View {
        Button {
            guard selectedCategory != category else { return }

            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                selectedCategory = category
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                    .fill(category == selectedCategory ? category.color : LunaraColor.secondary.opacity(0.35))
                    .overlay {
                        RoundedRectangle(cornerRadius: LunaraRadius.regular, style: .continuous)
                            .stroke(
                                category == selectedCategory ? LunaraColor.focusedBorder : LunaraColor.border,
                                lineWidth: 1
                            )
                    }

                Image(category.image)
                    .renderingMode(.template)
                    .foregroundStyle(iconColor(for: category))
                    .scaleEffect(category == selectedCategory ? 1.08 : 1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.itemHeight)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(category.displayName)
        .accessibilityAddTraits(category == selectedCategory ? [.isButton, .isSelected] : .isButton)
    }

    func iconColor(for category: DreamCategory) -> Color {
        category == selectedCategory ? LunaraColor.cream : category.color
    }
}

// Preview wrapper
private struct CategorySelectionViewWrapper: View {
    @State private var selectedCategory: DreamCategory = .lucid

    var body: some View {
        ZStack {
            LunaraColor.background
                .ignoresSafeArea()

            CategorySelectionView(selectedCategory: $selectedCategory)
        }
    }
}

#Preview {
    CategorySelectionViewWrapper()
}
