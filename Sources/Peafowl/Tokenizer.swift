import Foundation

private func move<T: Token>(_ token: T, from tiles: inout [Tile], to tokens: inout [T]) {
    tiles.remove(token)
    tokens.append(token)
}

internal protocol Tokenizer {
    associatedtype Form
    init()
    func tokenize(from tiles: [Tile]) -> [Form]
}

extension Tokenizer {
    internal func findEyes(from tiles: [Tile]) -> [PairToken] {
        var mutableTiles = tiles
        var results: [PairToken] = []
        for tile in tiles {
            if mutableTiles.count(tile) >= 2 {
                guard let newPair = PairToken((tile, tile)) else { continue }
                move(newPair, from: &mutableTiles, to: &results)
            }
        }
        return results
    }
    
    internal func findTripletMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return Set(tiles.compactMap { tile in
            if tiles.count(tile) >= 3 {
                return MeldToken((tile, tile, tile))
            }
            return nil
        })
    }
    
    internal func findSequentialMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return Set(tiles.compactMap { tile in
            guard let previousTile = tile.previous, tiles.contains(previousTile) else {
                return nil
            }
            guard let nextTile = tile.next, tiles.contains(nextTile) else {
                return nil
            }
            return MeldToken((previousTile, tile, nextTile))
        })
    }
}

internal struct OrdinaryFormTokenizer: Tokenizer {
    typealias Form = WinningForm
    
    func findMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return findSequentialMelds(from: tiles).union(findTripletMelds(from: tiles))
    }
    
    func tokenize(from tiles: [Tile]) -> [Form] {
        let eyes = Set(findEyes(from: tiles))
        let forms: [WinningForm] = eyes.map { eye in
            let currentTiles = tiles.removed(eye)
            let searchedMelds = searchMelds(remainingTiles: currentTiles)
            for melds in searchedMelds {
                if melds.count == 4 {
                    let form: WinningForm = (eye, melds[0], melds[1], melds[2], melds[3])
                    return form
                }
            }
            return nil
            }.compactMap { $0 }
        return forms
    }
    
    private func searchMelds(remainingTiles: [Tile],
                             context: [MeldToken] = [],
                             searchedMelds: Set<[MeldToken]> = Set()) -> Set<[MeldToken]> {
        let melds = findMelds(from: remainingTiles)
        return melds.reduce(into: Set<[MeldToken]>()) { searchedMelds, meld in
            let newRemainingTiles = remainingTiles.removed(meld)
            let newContext = context + [meld]
            if newContext.count == 4 {
                searchedMelds.insert(newContext)
            } else {
                let recursiveSearchedMelds = searchMelds(remainingTiles: newRemainingTiles,
                                                         context: newContext ,
                                                         searchedMelds: searchedMelds)
                searchedMelds.formUnion(recursiveSearchedMelds)
            }
        }
    }
}
