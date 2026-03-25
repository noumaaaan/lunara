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

    private let columns = Array(repeating: GridItem(.flexible(), spacing: Constants.gridSpacing), count: 6)

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Text("Dream Category")
                    .font(LunaraFont.lightBodySmall)
                    .foregroundStyle(LunaraColor.cream.opacity(0.9))

                Spacer()
                
                Text(selectedCategory.displayName)
                    .font(LunaraFont.semiBoldBody)
                    .foregroundStyle(LunaraColor.cream)
            }
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
                ForEach(DreamCategory.allCases, id: \.self) { category in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                            selectedCategory = category
                        }
                    } label: {
                        Image(category.image)
                            .foregroundStyle(iconColor(for: category))
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.itemHeight)
                            .background(background(for: category))
                            .scaleEffect(category == selectedCategory ? 1.1 : 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    private func iconColor(for category: DreamCategory) -> Color {
        category == selectedCategory ? LunaraColor.cream : category.color
    }

    @ViewBuilder
    private func background(for category: DreamCategory) -> some View {
        RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
            .fill(category == selectedCategory ? category.color : LunaraColor.secondary.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                    .stroke(
                        category == selectedCategory ? LunaraColor.focusedBorderColor : LunaraColor.borderColor,
                        lineWidth: 1
                    )
            }
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
