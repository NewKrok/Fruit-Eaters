package fe.game.ui;

import fe.game.GameModel;
import h2d.Flow;
import h2d.Layers;
import h2d.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class GameUI extends Flow
{
	var goalUI:GoalUI;
	var movesUI:MovesUI;
	var helpsUI:HelpsUI;

	public function new(parent:Sprite, gameModel:GameModel)
	{
		super(parent);

		isVertical = false;
		horizontalSpacing = 20;

		goalUI = new GoalUI(this);
		movesUI = new MovesUI(this, gameModel.remainingMoves);
		helpsUI = new HelpsUI(this);
	}
}