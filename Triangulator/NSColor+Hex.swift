//
//  NSColor+Hex.swift
//  Triangulator
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak.
//
//  Triangulator is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//

import Cocoa

let digitValues: [Character: Int] = [
    "0":  0, "1":  1, "2":  2, "3":  3,
    "4":  4, "5":  5, "6":  6, "7":  7,
    "8":  8, "9":  9, "a": 10, "b": 11,
    "c": 12, "d": 13, "e": 14, "f": 15
]

// Operator potęgowania a'la Ruby
// Wartość precedence ukradziona ze StackOverflow
infix operator ** { associativity left precedence 170 };

func ** (num: Int, power: Int) -> Int {
    return Int(pow(Double(num), Double(power)))
}

// "abc012" => 0xabc0123
func parseHexInt(hexString: String) -> Int {
    var result: Int = 0
    for (pos, char) in Array(hexString.characters.reverse()).enumerate() {
        if let digit = digitValues[char] {
            result += digit * 16 ** pos
        }
        else {
            break
        }
    }
    return result
}

// "abc012" => (r: 0xab, g: 0xc0, b: 0x12)
func parseHexColor(hexString: String) -> (r: Int, g: Int, b: Int) {
    let num = parseHexInt(hexString)
    return (
        r: (num >> 16) & 0xff,
        g: (num >>  8) & 0xff,
        b: (num      ) & 0xff
    )
}

public extension NSColor {
    public convenience init(hexString: String) {
        let values = parseHexColor(hexString)
        self.init(calibratedRed: CGFloat(values.r) / 255.0,
            green: CGFloat(values.g) / 255.0,
            blue: CGFloat(values.b) / 255.0,
            alpha: 1)
    }
}