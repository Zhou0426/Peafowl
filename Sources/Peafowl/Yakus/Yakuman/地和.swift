import Foundation

public struct 地和: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 13
    
    public let name = "地和"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 地和? {
        if !context.isDealer && context.pickedSource == .firstTile {
            return 地和()
        }
        return nil
    }
}
