package ;

import flixel.addons.weapon.FlxWeapon;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.ui.FlxBar;

class Enemy extends Entity
{
	public var timer:FlxTimer;
	public var opts:TweenOptions;
	public var tween:FlxTween;
	public var bar:FlxBar;

	override public function new(x:Int, y:Int):Void
	{
		super(x, y, 150, "blu", flixel.addons.weapon.FlxWeapon.BULLET_DOWN);

		sprite.health = 50;

		timer = new FlxTimer(0.5, function (i:FlxTimer):Void
		{
			fire();
		}, 0);

		sprite.makeGraphic(16, 32, 0xFFFFFFFF);
		updateBulletOffset();

		bar = new FlxBar(x - 7, y, FlxBar.FILL_BOTTOM_TO_TOP, 5, cast(sprite.height, Int), sprite, "health", 0, 50);
		bar.createFilledBar(0xFF000000, 0xFFCF0000, true, 0xFFFFFFFF);
		bar.trackParent(-7, 0);
		bar.killOnEmpty = true;
		add(bar);

		opts = {ease : FlxEase.quadInOut,	type : FlxTween.ONESHOT};
	}

	public function movePath(points:Array<flixel.util.FlxPoint>, duration:Float ):Void
	{
		tween = FlxTween.quadPath(sprite, points, duration, true, opts);
	}
}