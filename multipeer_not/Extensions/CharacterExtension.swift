//
//  CharacterExtension.swift
//  multipeer_not
//
//  Created by Miguel Angel Sicart on 22/01/2020.
//  Copyright © 2020 playable_systems. All rights reserved.
//

import Foundation
import Swift

extension Character {
    var isVowel: Bool {
        return "aeiouAEIOU".contains {
            String($0).compare(String(self).folding(options: .diacriticInsensitive, locale: nil), options: .caseInsensitive) == .orderedSame
        }
    }
}

