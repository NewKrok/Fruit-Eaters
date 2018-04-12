package fe.game;

import fe.asset.ElemTile;
import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Elem
{
	public static var SIZE(default, null):UInt = 105;

	public var hasMouseHover(default, set):Bool = false;
	public var id(default, null):UInt = Math.floor(Math.random() * 99999);

	public var indexX:UInt;
	public var indexY:UInt;
	public var animationX:Float;
	public var animationY:Float;
	public var rotation:Float;
	public var type(default, set):ElemType;
	public var isUnderSwapping:Bool;
	public var graphic:ElemGraphic;
	public var animationPath:Array<SimplePoint>;
	public var isUsedForCrossAnimation:Bool;

	public function new(row:UInt, col:UInt, type:ElemType = ElemType.Random)
	{
		indexX = col;
		indexY = row;
		animationX = col * SIZE;
		animationY = row * SIZE;
		rotation = 0;
		isUnderSwapping = false;
		isUsedForCrossAnimation = false;

		animationPath = [];

		graphic = new ElemGraphic();

		this.type = type == ElemType.Random ? cast(1 + Math.floor(Math.random() * 7)) : type;

		graphic.x = animationX;
		graphic.y = animationY;

		if (type == ElemType.Empty || type == ElemType.None) graphic.visible = false;
	}

	function set_type(v:ElemType):ElemType
	{
		type = v;

		if (type == ElemType.Empty || type == ElemType.None || type == null) graphic.setTile(ElemTile.emptyElemGraphic);
		else graphic.setTile(ElemTile.tiles.get(cast type));

		switch (type)
		{
			case ElemType.Empty: graphic.visible = false;
			case ElemType.None: graphic.visible = false;
			case _:
		}

		return v;
	}

	function set_hasMouseHover(value:Bool):Bool
	{
		graphic.hasMouseHover = value;

		return hasMouseHover = value;
	}
}

@:enum abstract ElemType(Int)
{
	var Blocker = 0;
	var Empty = -1;
	var Random = -2;
	var None = -3;
}