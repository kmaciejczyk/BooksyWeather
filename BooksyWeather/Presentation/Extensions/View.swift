//
//  View.swift
//  BooksyWeather
//
//  Created by Paweł Madej on 02/06/2022.
//

import SwiftUI

public extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
