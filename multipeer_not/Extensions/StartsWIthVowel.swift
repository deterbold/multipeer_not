//
//  StartsWIthVowel.swift
//  multipeer_not
//
//  Created by Miguel Angel Sicart on 22/01/2020.
//  Copyright © 2020 playable_systems. All rights reserved.
//

import Foundation
import Swift

extension StringProtocol {
    var startsWithVowel: Bool {
        return first?.isVowel == true
    }
}

