//
//  FetchController.swift
//  Dex3
//
//  Created by Matt Maher on 6/24/23.
//

import Foundation

struct FetchController {
    enum NeworkError: Error {
        case badURL, badResponse, badData
    }

    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!

    func fetchAllPokemon() async throws -> [TempPokemon] {
        var allPokemon: [TempPokemon] = []
        let data = try await getFetchedData(baseURL, qsDict: ["limit": "386"])

        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let pokedex = pokeDictionary["results"] as? [[String: String]]
        else {
            throw NeworkError.badData
        }

        for pokemon in pokedex {
            if let url = pokemon["url"] {
                try allPokemon.append(await fetchPokemon(from: URL(string: url)!))
            }
        }

        return allPokemon
    }

    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let data = try await getFetchedData(url, qsDict: nil)
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        print("fetched \(tempPokemon.id): \(tempPokemon.name)")

        return tempPokemon
    }

    private func getFetchedData(_ url: URL, qsDict: [String: String]?) async throws -> Data {
        var fetchURL = url

        if qsDict != nil {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            var queryItems = [URLQueryItem]()
            for (key, value) in qsDict! {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = queryItems

            // verify url
            guard let newFetchURL = urlComponents?.url else {
                throw NeworkError.badURL
            }

            fetchURL = newFetchURL
        }

        // verify response
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NeworkError.badResponse
        }

        return data
    }
}
