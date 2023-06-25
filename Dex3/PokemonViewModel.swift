//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Matt Maher on 6/24/23.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }

    @Published private(set) var status = status.notStarted

    private let controller: FetchController

    init(controller: FetchController) {
        self.controller = controller

        Task {
            await self.getPokemon()
        }
    }

    private func getPokemon() async {
        self.status = .fetching

        do {
            var pokedex = try await self.controller.fetchAllPokemon()

            pokedex.sort { $0.id < $1.id }

            for pokemon in pokedex {
                let viewContext = PersistenceController.shared.container.viewContext
                let newPokemon = Pokemon(context: viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false

                try viewContext.save()
            }

        } catch {
            self.status = .failed(error: error)
        }
    }
}
