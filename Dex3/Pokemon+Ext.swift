//
//  Pokemon+Ext.swift
//  Dex3
//
//  Created by Matt Maher on 6/24/23.
//

import Foundation

extension Pokemon {
    var background: String {
        switch self.types![0] {
        case "normal", "grass", "electric", "poison", "fairy":
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"

        default:
            return "normalgrasselectricpoisonfairy"
        }
    }

    var stats: [Stat] {
        [
            Stat(id: 1, label: "hp", value: self.hp),
            Stat(id: 2, label: "attack", value: self.attack),
            Stat(id: 3, label: "defense", value: self.defense),
            Stat(id: 4, label: "specialAttack", value: self.specialAttack),
            Stat(id: 5, label: "specialDefense", value: self.specialDefense),
            Stat(id: 6, label: "speed", value: self.speed),
        ]
    }
    
    var highestStat: Stat {
        stats.max { $0.value < $1.value }!
    }
    
    func organizeTypes() {
        if self.types?.count == 2 && self.types![0] == "normal" {
            self.types!.swapAt(0, 1)
        }
    }
}

struct Stat: Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
