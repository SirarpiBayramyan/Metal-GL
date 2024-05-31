//
//  BoardViewDetails.swift
//  2048
//
//  Created by Sirarpi Bayramyan on 18.09.23.
//

import SwiftUI

struct BoardViewDetails {

 private let colorScheme: [(Color, Color)] = [
    // 2
    (Color(red:0.91, green:0.87, blue:0.83, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity:1.00)),
    // 4
    (Color(red:0.90, green:0.86, blue:0.76, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity:1.00)),
    // 8
    (Color(red:0.93, green:0.67, blue:0.46, opacity:1.00), Color.white),
    // 16
    (Color(red:0.94, green:0.57, blue:0.38, opacity:1.00), Color.white),
    // 32
    (Color(red:0.95, green:0.46, blue:0.33, opacity:1.00), Color.white),
    // 64
    (Color(red:0.94, green:0.35, blue:0.23, opacity:1.00), Color.white),
    // 128
    (Color(red:0.91, green:0.78, blue:0.43, opacity:1.00), Color.white),
    // 256
    (Color(red:0.91, green:0.78, blue:0.37, opacity:1.00), Color.white),
    // 512
    (Color(red:0.90, green:0.77, blue:0.31, opacity:1.00), Color.white),
    // 1024
    (Color(red:0.91, green:0.75, blue:0.24, opacity:1.00), Color.white),
    // 2048
    (Color(red:0.91, green:0.74, blue:0.18, opacity:1.00), Color.white),
  ]

  func colorPair(number: Int?) -> (Color, Color) {
    guard let number = number else {
      return (Color(red:0.78, green:0.73, blue:0.68, opacity:1.00), Color.black)
    }
    let index = Int(log2(Double(number))) - 1
    if index < 0 || index >= colorScheme.count {
      fatalError("No color for such number")
    }
    return colorScheme[index]
  }
  
  func fontSize(number: Int?) -> CGFloat {
    let textLength = numberText(number: number).count
    if textLength < 3 {
      return 32
    } else if textLength < 4 {
      return 18
    } else {
      return 12
    }
  }
  
  func numberText(number: Int?) -> String {
     guard let number = number else {
       return ""
     }
     return String(number)
   }

}
