import Foundation

public struct 立直: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 1
    
    public let name = "立直"
    public static func make(with tiles: [Tile], form: OrdinaryWinningForm?, picked: Tile, context: GameContext) -> 立直? {
        if context.isRiichi {
            return 立直()
        }
        return nil
    }
}
