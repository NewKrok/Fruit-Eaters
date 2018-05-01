package fe.state;

import fe.menu.MenuLayout;
import fe.menu.ui.LevelButton;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Layers;
import hpp.heaps.Base2dState;
import hpp.heaps.Base2dSubState;
import hpp.heaps.HppG;
import hpp.util.GeomUtil;
import hxd.Event;
import hxd.Res;
import hxd.res.Sound;
import hxd.Cursor;
import fe.menu.substate.CampaignPage;
import fe.menu.substate.SettingsPage;
import fe.menu.substate.WelcomePage;
import motion.Actuate;
import motion.easing.Linear;

class MenuState extends Base2dState
{
	var menuContainer:Layers;
	var interactiveArea:Interactive;

	var layout:MenuLayout;

	var welcomePage:WelcomePage;
	var settingsPage:SettingsPage;
	var campaignPage:CampaignPage;

	var backgroundLoopMusic:Sound;
	var subStateChangeSound:Sound;

	var isDragging:Bool = false;
	var dragStartPoint:SimplePoint = { x: 0, y: 0 };
	var dragStartContainerPoint:SimplePoint = { x: 0, y: 0 };
	var dragForce:Float = 0;
	var prevCheckForceYPoint:Int = 0;
	var dragForceTime:Float = 0;

	override function build()
	{
		//backgroundLoopMusic = if (Sound.supportedFormat(Mp3)) Res.sound.Eerie_Cyber_World_Looping else null;
		//subStateChangeSound = if (Sound.supportedFormat(Mp3)) Res.sound.UI_Quirky20 else null;

		interactiveArea = new Interactive(stage.width, stage.height, stage);
		interactiveArea.cursor = Cursor.Default;

		menuContainer = new Layers(stage);

		var backgroundTop = new Bitmap(Res.image.menu.map_top.toTile(), menuContainer);
		backgroundTop.smooth = true;
		backgroundTop.setScale(AppConfig.GAME_BITMAP_SCALE);

		var backgroundBottom = new Bitmap(Res.image.menu.map_bottom.toTile(), menuContainer);
		backgroundBottom.smooth = true;
		backgroundBottom.setScale(AppConfig.GAME_BITMAP_SCALE);
		backgroundBottom.y = backgroundTop.getSize().height;

		var levelButtonPoints:Array<SimplePoint> = [
			{ x: 1729, y: 3858 },
			{ x: 1270, y: 3603 },
			{ x: 766, y: 3718 },
			{ x: 317, y: 3556 },
			{ x: 486, y: 3183 },
			{ x: 982, y: 3155 },
			{ x: 1250, y: 2832 },
			{ x: 1628, y: 2543 },
			{ x: 1788, y: 2110 },
			{ x: 1330, y: 1896 },
			{ x: 926, y: 2117 },
			{ x: 567, y: 2363 },
			{ x: 237, y: 2133 },
			{ x: 290, y: 1659 },
			{ x: 655, y: 1393 },
			{ x: 1074, y: 1273 },
			{ x: 1471, y: 1172 },
			{ x: 1701, y: 815 },
			{ x: 1552, y: 384 },
			{ x: 1028, y: 71 }
		];
		var buttonPadding = 20;
		for (i in 0...levelButtonPoints.length)
		{
			var levelButton = new LevelButton(menuContainer, i, startLevel);
			levelButton.x = (levelButtonPoints[i].x + levelButton.getSize().width / 2 + buttonPadding) * AppConfig.GAME_BITMAP_SCALE;
			levelButton.y = (levelButtonPoints[i].y + levelButton.getSize().height / 2 + buttonPadding) * AppConfig.GAME_BITMAP_SCALE;
		}

		interactiveArea.onPush = function(e:Event)
		{
			Actuate.stop(menuContainer);

			isDragging = true;
			dragStartPoint.x = e.relX;
			dragStartPoint.y = e.relY;
			dragStartContainerPoint.x = menuContainer.x;
			dragStartContainerPoint.y = menuContainer.y;

			dragForce = 0;
			prevCheckForceYPoint = Std.int(e.relY);
		};

		interactiveArea.onRelease = function(_)
		{
			if (isDragging && Date.now().getTime() - dragForceTime < 30)
			{
				Actuate.stop(menuContainer);
				Actuate.tween(menuContainer, Math.abs(.02 * dragForce), {
					y: normalizeContainerY(menuContainer.y + dragForce * 5)
				}).onUpdate(function() {
					menuContainer.y = menuContainer.y;
				});
			}

			isDragging = false;
		};

		interactiveArea.onMove = function(e:Event)
		{
			if (isDragging)
			{
				var d = GeomUtil.getDistance({ x: e.relX, y: e.relY }, dragStartPoint);

				if (d > 10)
				{
					menuContainer.y = normalizeContainerY(dragStartContainerPoint.y + (e.relY - dragStartPoint.y));
					dragForce = e.relY - prevCheckForceYPoint;
					prevCheckForceYPoint = Std.int(e.relY);
					dragForceTime = Date.now().getTime();
				}
			}
		};

		welcomePage = new WelcomePage();
		settingsPage = new SettingsPage();
		campaignPage = new CampaignPage();

		layout = new MenuLayout(
			stage,
			menuContainer,
			interactiveArea
		);

		openSubState(welcomePage);
		onStageResize(0, 0);

		menuContainer.y = -menuContainer.getSize().height + stage.height;
	}

	function startLevel(levelId:UInt):Void
	{
		HppG.changeState(GameState, [levelId]);
	}

	function normalizeContainerY(baseY:Float):Float
	{
		baseY = Math.max(baseY, -menuContainer.getSize().height + stage.height);
		baseY = Math.min(baseY, 0);

		return baseY;
	}

	function openWelcomePage()
	{
		playSubStateChangeSound();
		openSubState(welcomePage);
	}

	function openSettingsPage()
	{
		playSubStateChangeSound();
		openSubState(settingsPage);
	}

	function openCampaignPage()
	{
		playSubStateChangeSound();
		openSubState(campaignPage);
	}

	override function onSubStateChanged(activeSubState:Base2dSubState):Void
	{
	}

	function playSubStateChangeSound():Void
	{
		if (subStateChangeSound != null) subStateChangeSound.play();
	}

	override public function onStageResize(width:UInt, height:UInt)
	{
		super.onStageResize(width, height);

		Actuate.stop(menuContainer);
		menuContainer.y = normalizeContainerY(menuContainer.y);

		layout.update(width, height);
	}

	function resumeRequest()
	{
		Actuate.resumeAll();
	}

	function pauseRequest()
	{
		Actuate.pauseAll();
	}

	override public function onFocus()
	{
		resumeRequest();
	}

	override public function onFocusLost()
	{
		pauseRequest();
	}

	override public function dispose()
	{
		/*backgroundLoopMusic.stop();
		backgroundLoopMusic.dispose();
		subStateChangeSound.stop();
		subStateChangeSound.dispose();*/

		super.dispose();
	}
}