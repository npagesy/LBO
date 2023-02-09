//
//  LBOApp.swift
//  LBO
//
//  Created by Noeline PAGESY on 06/02/2023.
//

import SwiftUI

@main
struct LBOApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(serviceProvider: BookServiceProvider(), storage: UserDefaultDataStore()))
        }
    }
}
