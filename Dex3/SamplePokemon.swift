//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Matt Maher on 6/24/23.
//

import CoreData
import Foundation

struct SamplePokemon {
    static let samplePokemon: Pokemon = {
        let context = PersistenceController.preview.container.viewContext

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1

        let results = try! context.fetch(fetchRequest)
        return results.first!
    }()
}
