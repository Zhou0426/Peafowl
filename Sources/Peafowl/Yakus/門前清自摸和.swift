import Foundation

public struct 門前清自摸和: YakuProtocol {
    public let openedHan: Int? = nil
    public let concealedHan: Int = 1
    
    public let name = "ツモ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 門前清自摸和? {
        if context.winningType == .selfPick && isConcealed(form) {
            return 門前清自摸和()
        }
        return nil
    }
}
