//
//  AppErrorState.swift
//  Lunara
//
//  Created by Noumaan Mehmood on 26/03/2026.
//

import Foundation

struct AppErrorState: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
}
