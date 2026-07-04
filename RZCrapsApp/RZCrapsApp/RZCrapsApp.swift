//
//  RZCrapsAppApp.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 6/30/26.
//

import SwiftUI
import RZCrapsEngine

@main
struct RZCrapsApp: App {
    @StateObject private var viewModel = CrapsViewModel()

    var body: some Scene {
        WindowGroup {
            CrapsTableView()
                .environmentObject(viewModel)
        }
    }
}

