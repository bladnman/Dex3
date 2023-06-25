//
//  Dex3WidgetBundle.swift
//  Dex3Widget
//
//  Created by Matt Maher on 6/25/23.
//

import WidgetKit
import SwiftUI

@main
struct Dex3WidgetBundle: WidgetBundle {
    var body: some Widget {
        Dex3Widget()
        Dex3WidgetLiveActivity()
    }
}
