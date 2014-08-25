package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxRect;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxVelocity;
import flixel.addons.plugin.control.FlxControl;
import flixel.addons.plugin.control.FlxControlHandler;
import flixel.addons.display.FlxStarField;
import flixel.util.FlxTimer;
import flixel.util.loaders.TexturePackerData;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var player:Player;
	private var ready:FlxSprite;
	private var starfield:FlxStarField2D;
	private var cooldown:Bool = false;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		starfield = new FlxStarField2D(0, 0, FlxG.width, FlxG.height, 200);
		starfield.starVelocityOffset.y = 1;
		starfield.starVelocityOffset.x = 0;
		starfield.setStarDepthColors(5, 0xFF555555, 0xFFAAAAAA);
		add(starfield);

		player = new Player();
		add(player);

		var enemy = new Enemy(100, 100);
		enemy.movePath([new FlxPoint(100, 100), new FlxPoint(300, 300), new FlxPoint(600, 100)], 10);
		add(enemy);

		if(FlxG.plugins.get(FlxControl) == null)
		{
			FlxG.plugins.add(new FlxControl());
		}

		FlxControl.create(player.sprite, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false, false);
		FlxControl.player1.setFireButton("Z", FlxControlHandler.KEYMODE_PRESSED, 300, player.fire);
		FlxControl.player1.setMovementSpeed(Player.movespeed, Player.movespeed, Player.movespeed, Player.movespeed);
		FlxControl.player1.setWASDControl(true, true, true, true);
		FlxControl.player1.setCursorControl(true, true, true, true);

		ready = new FlxSprite(0, 0);
		var spritesheet = new TexturePackerData("assets/images/button.json", "assets/images/button.png");
		ready.loadGraphicFromTexture(spritesheet);
		ready.animation.addByNames("on", ["on.png"]);
		ready.animation.addByNames("off", ["off.png"]);
		ready.animation.play("on");
		ready.resetSizeFromFrame();
		ready.centerOrigin();
		ready.scale.x = 2;
		ready.scale.y = 2;
		ready.updateHitbox();
		ready.x = 10;
		ready.y = FlxG.height - ready.height - 10;
		add(ready);
	}

	public function bulletCollide(b:FlxObject, s:FlxObject):Void
	{
		if(b.ID != s.ID)
		{
			s.hurt(50);
			b.kill();
		}
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if(!cooldown && FlxG.keys.justReleased.X)
		{
			cooldown = true;

			var timer = new FlxTimer(3, function (i:FlxTimer):Void
			{
				cooldown = false;
			}, 0);

			for(e in Reg.entities)
				e.switchColors();
		}

		if(cooldown && ready.animation.name == "on")
			ready.animation.play("off");
		else if(!cooldown && ready.animation.name == "off")
			ready.animation.play("on");

		for(w in Reg.weapons)
			for(e in Reg.entities)
				FlxG.overlap(w.group, e.sprite, bulletCollide);

		super.update();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
}