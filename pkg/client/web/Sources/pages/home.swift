// SPDX-License-Identifier: GPL-3.0
//
//  home.swift
//  helloweb
//
//  Created by Schubert Anselme on 2024-11-11.
//

import Foundation
import Ignite

struct Home: StaticPage {
  var title = "Home"

  func body(context: PublishingContext) async -> [BlockElement] {
    Text("Welcome to hello web!").font(.title1)
    Accordion {
      Item("Greeter") {
        Text("todo: add greeter input")
        Divider()
        Text {
          Button("Send")
            .role(.primary)
            .onClick(actions: {})  // todo: add onclick action
        }
      }
    }
    .openMode(.individual)
    .margin(.bottom, .extraLarge)
  }
}
