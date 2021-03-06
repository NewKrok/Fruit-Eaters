package fe.menu.ui;

import fe.common.ui.SocialUI;
import h2d.Layers;
import h2d.Sprite;
import hpp.heaps.HppG;
import hpp.heaps.ui.BaseButton;
import hxd.Res;

/**
 * ...
 * @author Krisztian Somoracz
 */
class MenuUI extends Layers
{
	var hppServicesButton:BaseButton;
	var socials:SocialUI;

	public function new(
		parent:Sprite,
		openHPPServices:Void->Void
	){
		super(parent);

		hppServicesButton = new BaseButton(this, {
			onClick: function(_){ openHPPServices(); },
			baseGraphic: Res.image.common.ui.hpps_logo_black_and_white_200px.toTile(),
			overScale: .9
		});
		hppServicesButton.visible = false;
		hppServicesButton.setScale(AppConfig.GAME_BITMAP_SCALE);

		socials = new SocialUI(this);
	}

	public function updateScale(v:Float):Void
	{
		hppServicesButton.setScale(AppConfig.GAME_BITMAP_SCALE * v);
		hppServicesButton.x = 20;
		hppServicesButton.y = HppG.stage2d.height - hppServicesButton.getSize().height - 20;

		socials.setScale(AppConfig.GAME_BITMAP_SCALE * v);
		socials.y = HppG.stage2d.height / 2 - socials.getSize().height / 2 - 20;
	}
}