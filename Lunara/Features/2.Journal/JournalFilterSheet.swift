//
//  JournalFilterSheet.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 25/03/2026.
//

import SwiftUI

private enum Constants {
    static let screenPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 18
    static let gridSpacing: CGFloat = 8
}

struct JournalFilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedCategories: Set<DreamCategory>
    @Binding var selectedMoods: Set<WakingMood>
    @Binding var selectedIntensities: Set<DreamIntensity>

    let resetAction: () -> Void

    private let categoryColumns = Array(repeating: GridItem(.flexible(), spacing: Constants.gridSpacing), count: 6)
    private let moodColumns = Array(repeating: GridItem(.flexible(), spacing: Constants.gridSpacing), count: 5)
    private let intensityColumns = Array(repeating: GridItem(.flexible(), spacing: Constants.gridSpacing), count: 2)

    var body: some View {
        NavigationStack {
            ZStack {
                LunaraColor.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                        section("Category") {
                            categorySelection(columns: categoryColumns)
                        }

                        Divider()
                            .overlay(LunaraColor.borderColor)

                        section("Waking Mood") {
                            moodSelection(columns: moodColumns)
                        }

                        Divider()
                            .overlay(LunaraColor.borderColor)

                        section("Intensity") {
                            intensitySelection(columns: intensityColumns)
                        }
                    }
                    .padding(Constants.screenPadding)
                    .padding(.bottom, 30)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(LunaraColor.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Filters")
                        .font(.manropeBold(size: 18))
                        .foregroundStyle(LunaraColor.cream)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        resetAction()
                    }
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream.opacity(0.8))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(LunaraFont.body)
                    .foregroundStyle(LunaraColor.cream)
                }
            }
        }
    }
}

private extension JournalFilterSheet {
    @ViewBuilder
    func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.manropeLight(size: 11))
                .textCase(.uppercase)
                .foregroundStyle(LunaraColor.cream.opacity(0.7))

            content()
        }
    }

    func categorySelection(columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: Constants.gridSpacing) {
            ForEach(DreamCategory.allCases, id: \.self) { category in
                let isSelected = selectedCategories.contains(category)

                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                        toggle(category, in: $selectedCategories)
                    }
                } label: {
                    Image(category.image)
                        .foregroundStyle(isSelected ? LunaraColor.cream : category.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                                .fill(isSelected ? category.color : LunaraColor.secondary.opacity(0.35))
                                .overlay {
                                    RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                                        .stroke(
                                            isSelected ? LunaraColor.focusedBorderColor : LunaraColor.borderColor,
                                            lineWidth: 1
                                        )
                                }
                        )
                        .scaleEffect(isSelected ? 1.08 : 1)
                }
                .buttonStyle(.plain)
            }
        }
    }

    func moodSelection(columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
            ForEach(WakingMood.allCases, id: \.self) { mood in
                let isSelected = selectedMoods.contains(mood)

                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                        toggle(mood, in: $selectedMoods)
                    }
                } label: {
                    Image(mood.image)
                        .foregroundStyle(isSelected ? LunaraColor.cream : mood.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                                .fill(isSelected ? mood.color : LunaraColor.secondary.opacity(0.35))
                                .overlay {
                                    RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                                        .stroke(
                                            isSelected ? LunaraColor.focusedBorderColor : LunaraColor.borderColor,
                                            lineWidth: 1
                                        )
                                }
                        )
                        .scaleEffect(isSelected ? 1.08 : 1)
                }
                .buttonStyle(.plain)
            }
        }
    }

    func intensitySelection(columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
            ForEach(DreamIntensity.allCases, id: \.self) { intensity in
                let isSelected = selectedIntensities.contains(intensity)

                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                        toggle(intensity, in: $selectedIntensities)
                    }
                } label: {
                    Text(intensity.displayName)
                        .font(LunaraFont.body)
                        .foregroundStyle(isSelected ? LunaraColor.cream : intensity.color)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                                .fill(isSelected ? intensity.color : LunaraColor.secondary.opacity(0.35))
                                .overlay {
                                    RoundedRectangle(cornerRadius: LunaraLayout.cornerRadius, style: .continuous)
                                        .stroke(
                                            isSelected ? LunaraColor.focusedBorderColor : LunaraColor.borderColor,
                                            lineWidth: 1
                                        )
                                }
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    func toggle<T: Hashable>(_ value: T, in set: Binding<Set<T>>) {
        if set.wrappedValue.contains(value) {
            set.wrappedValue.remove(value)
        } else {
            set.wrappedValue.insert(value)
        }
    }
}

#Preview {
    JournalFilterSheetPreviewContainer()
}

private struct JournalFilterSheetPreviewContainer: View {
    @State private var categories: Set<DreamCategory> = [.happy, .weird]
    @State private var moods: Set<WakingMood> = [.calm]
    @State private var intensities: Set<DreamIntensity> = [.moderatelyIntense]

    var body: some View {
        JournalFilterSheet(
            selectedCategories: $categories,
            selectedMoods: $moods,
            selectedIntensities: $intensities,
            resetAction: {
                categories.removeAll()
                moods.removeAll()
                intensities.removeAll()
            }
        )
    }
}
