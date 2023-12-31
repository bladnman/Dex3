//
//  TempPokemon.swift
//  Dex3
//
//  Created by Matt Maher on 6/24/23.
// example
// https://pokeapi.co/api/v2/pokemon/bulbasaur

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp: Int
    var attack: Int
    var defense: Int
    var specialAttack: Int
    var specialDefense: Int
    var speed: Int
    let sprite: URL
    let shiny: URL

    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites

        enum TypeDictionaryKeys: String, CodingKey {
            case type

            enum TypeKeys: String, CodingKey {
                case name
            }
        }

        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat

            enum StatKeys: String, CodingKey {
                case name
            }
        }

        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)

        // TYPES
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)

            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        self.types = decodedTypes

        // STATS
        self.hp = 0
        self.attack = 0
        self.defense = 0
        self.specialAttack = 0
        self.specialDefense = 0
        self.speed = 0

        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            let statName = try statContainer.decode(String.self, forKey: .name)
            switch statName {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("some other stat value, not mapped: \(statName)")
            }
        }

        // SPRITES
        let spritesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        self.sprite = try spritesContainer.decode(URL.self, forKey: .sprite)
        self.shiny = try spritesContainer.decode(URL.self, forKey: .shiny)
    }
}
