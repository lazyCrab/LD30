package ;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;

class Entity extends FlxGroup
{
	public var sprite:FlxSprite;
	public var gun:FlxWeapon;

	public function new(x:Int, y:Int, movespeed:Int, bulletColor:String, bulletDirection:Int)
	{
		super();

		sprite = new FlxSprite(x, y);
		sprite.maxVelocity.x = movespeed;
		sprite.maxVelocity.y = movespeed;
		add(sprite);

		gun = new FlxWeapon(bulletColor, sprite);
		gun.setBulletDirection(bulletDirection, 200);
		gun.setBulletBounds(FlxG.worldBounds);

		if(bulletColor == "red")
		{
			sprite.color=0xFFFF0000;
			sprite.ID = 0;
			gun.makeImageBullet(100, "assets/images/bullet.png");
			gun.group.setAll("color", 0xFFFF0000);
			gun.group.setAll("ID", 0);
		}
		else
		{
			sprite.color=0xFF0000FF;
			sprite.ID = 1;
			gun.makeImageBullet(100, "assets/images/bullet.png");
			gun.group.setAll("color", 0xFF0000FF);
			gun.group.setAll("ID", 1);
		}

		if(bulletDirection == FlxWeapon.BULLET_DOWN)
			gun.setBulletOffset(7, sprite.height);

		add(gun.group);

		Reg.weapons.push(gun);
		Reg.entities.push(this);
	}

	public function updateBulletOffset():Void
	{
		gun.setBulletOffset((sprite.width - gun.group.getRandom().width) / 2, 0);
	}

	public function fire():Void
	{
		gun.fire();

		var bullet = gun.currentBullet;
		
		if(gun.name == "red")
		{
			if(bullet.ID != 0)
			{
				bullet.color = 0xFFFF0000;
				bullet.ID = 0;
			}
		}
		else
		{
			if(bullet.ID != 1)
			{
				bullet.color = 0xFF0000FF;
				bullet.ID = 1;
			}
		}
	}

	public function switchColors():Void
	{
		for(bullet in gun.group)
		{
			if(bullet.velocity.y != 0)
			{
				bullet.velocity.y = -bullet.velocity.y;
			}
		}

		if(gun.name == "red")
		{
			sprite.color=0xFF0000FF;
			sprite.ID = 1;
			gun.name = "blu";
		}
		else
		{
			sprite.color=0xFFFF0000;
			sprite.ID = 0;
			gun.name = "red";
		}
	}
}