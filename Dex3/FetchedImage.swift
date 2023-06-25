//
//  FetchedImage.swift
//  Dex3
//
//  Created by Matt Maher on 6/25/23.
//

import SwiftUI

struct FetchedImage: View {
    let url: URL?

    var body: some View {
        if let url,
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData)
        {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        } else {
            Image("bulbasaur")
        }
    }
}

struct FetchedImage_Previews: PreviewProvider {
    static var previews: some View {
        FetchedImage(url: SamplePokemon.samplePokemon.sprite)
    }
}
