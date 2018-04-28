package fe.asset;

import fe.game.Elem.ElemType;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Level
{
	static var data:Array<LevelData> =
	[
		{
			maxMovement: 20,
			availableElemTypes: [
				ElemType.Elem8,
				ElemType.Elem9,
				ElemType.Elem10,
				ElemType.Elem11,
				ElemType.Elem12,
				ElemType.Elem13
			],
			rawMap: [
				[ -3, -3, -2, -2, -2, -2, -3, -3 ],
				[ -3, -2, -2, -2, -2, -2, -2, -3 ],
				[ -2, -2, -2, -2, -2, -2, -2, -2 ],
				[ -2, -2, -2,  0,  0, -2, -2, -2 ],
				[ -2, -2, -2,  0,  0, -2, -2, -2 ],
				[ -2, -2, -2, -2, -2, -2, -2, -2 ],
				[ -3, -2, -2, -2, -2, -2, -2, -3 ],
				[ -3, -3, -2, -2, -2, -2, -3, -3 ]
			],
			starRequirements: [
				500,
				1200,
				2700
			],
			elemGoals: [
				ElemType.Elem8 => 5,
				ElemType.Elem9 => 10,
				ElemType.Elem10 => 5,
				ElemType.Elem12 => 10,
				ElemType.Elem13 => 5
			]
		}
	];

	public static function getLevelData(id:UInt):LevelData
	{
		return data[id];
	}
}

typedef LevelData =
{
	var maxMovement:UInt;
	var rawMap:Array<Array<Int>>;
	var availableElemTypes:Array<ElemType>;
	var starRequirements:Array<UInt>;
	@:optional var elemGoals:Map<ElemType, UInt>;
}