//
//  _048App.swift
//  2048
//
//  Created by Sirarpi Bayramyan on 18.09.23.
//

import SwiftUI

@main
struct G2048App: App {
    var body: some Scene {
        WindowGroup {
          GameView(viewModel: GameViewModel())
            .onAppear{
              print("AAAAAAAAAAAAAAAAAAAA")
            }
        }
    }
}
