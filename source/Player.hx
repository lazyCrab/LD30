package ;

import flixel.FlxG;
import flixel.util.loaders.TexturePackerData;
import flixel.addons.effects.FlxTrail;
import flixel.ui.FlxBar;

class Player extends Entity
{
	public inline static var movespeed = 200;
	public var trail:FlxTrail;
	public var bar:FlxBar;

	override public function new():Void
	{
		super(0, 0, movespeed, "red", flixel.addons.weapon.FlxWeapon.BULLET_UP);

		var spritesheet = new TexturePackerData("assets/images/spritesheet.json", "assets/images/spritesheet.png");
		sprite.loadGraphicFromTexture(spritesheet);
		sprite.animation.addByNames("idle", ["idle.png"]);
		sprite.animation.addByNames("up", ["up.png"]);
		sprite.animation.addByNames("down", ["down.png"]);
		sprite.animation.addByNames("left", ["left.png"]);
		sprite.animation.addByNames("right", ["right.png"]);
		sprite.animation.play("idle");
		sprite.resetSizeFromFrame();
		sprite.centerOrigin();

		sprite.x = (FlxG.width - sprite.width) / 2;
		sprite.y = FlxG.height - 100;

		sprite.health = 500;

		trail = new FlxTrail(sprite);
		trail.setAll("color", 0xFFFF0000);
		remove(sprite);
		add(trail);
		add(sprite);
		updateBulletOffset();

		bar = new FlxBar(0, 0, FlxBar.FILL_HORIZONTAL_INSIDE_OUT, FlxG.width, 15, sprite, "health", 0, 500);
		bar.createFilledBar(0xFF000000, 0xFFCF0000, true, 0xFFFFFFFF);
		add(bar);
	}

	override public function update():Void
	{
		if(sprite.velocity.x > 0)
			sprite.animation.play("right");
		else if (sprite.velocity.x < 0)
			sprite.animation.play("left");
		if(sprite.velocity.y < 0)
			sprite.animation.play("up");
		else if(sprite.velocity.y > 0)
			sprite.animation.play("down");
		
		if(sprite.velocity.x == 0 && sprite.velocity.y == 0)
			sprite.animation.play("idle");

		if(sprite.health <= 0)
			trail.kill();

		super.update();
	}

	override public function switchColors():Void
	{
		super.switchColors();

		if(gun.name == "red")
		{
			trail.setAll("color", 0xFFFF0000);
		}
		else
		{
			trail.setAll("color", 0xFF0000FF);
		}
	}
}