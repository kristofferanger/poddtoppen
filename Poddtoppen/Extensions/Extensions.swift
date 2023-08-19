//
//  Extensions.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-06.
//

import UIKit
import SwiftUI


extension Set where Iterator.Element: Hashable {
    mutating func toggleItem(_ item: Iterator.Element) {
        if self.contains(item) {
            self.remove(item)
        }
        else {
            self.insert(item)
        }
    }
}

extension Color {
    
    static func background() -> Color {
        return Color("Blue") // Color.accentColor.opacity(0.2)
    }
    
}

extension String {
    
    func htmlStripped() -> String {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let stripped = trimmed.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return stripped
    }
    
}


extension Double {
        
    var dateSting: String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.doesRelativeDateFormatting = true
        let date = Date(timeIntervalSince1970: self/1000.0)
        return relativeDateFormatter.string(from: date)
    }
}
