//
//  Globals.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import Foundation

class Globals {
    static var shared = Globals()

    private init() {}

    var tasks: [Task] = []
    var qrQuerry = ""
}
