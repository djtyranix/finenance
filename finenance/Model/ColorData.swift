//
//  Color.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import Foundation
import UIKit

struct ColorData {
    var colorType: ColorType
    var mainColor: UIColor
    var shadeColor: UIColor
}

enum ColorType {
    case dark, light
}
