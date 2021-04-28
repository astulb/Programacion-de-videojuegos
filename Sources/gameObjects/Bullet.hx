package gameObjects;

import com.gEngine.display.Sprite;
import states.GameConfig;
import com.collision.platformer.CollisionGroup;
import states.GlobalGameData;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Bullet extends Entity {
    var collision:CollisionBox;
	var speed:Float = GameConfig.bulletSpeed;
	var time:Float = 0;
    
    var sprite:Sprite;
    var displayScale = 0.2;
    private var spriteW = 0;
    private var spriteH = 0;

	public function new(x:Float, y:Float, collisionGroup:CollisionGroup) {
		super();
        sprite = new Sprite("bullet");
        spriteW = Std.int(sprite.width()*displayScale);
        spriteH = Std.int(sprite.height()*displayScale);
        sprite.x = x;
		sprite.y = y;
        sprite.scaleX = displayScale;
        sprite.scaleY = displayScale;
        GlobalGameData.simulationLayer.addChild(sprite);

		collision = new CollisionBox();
		collision.width = spriteW;
		collision.height = spriteH;
		collision.x = x - spriteW * 0.5;
		collision.y = y - spriteH * 0.5;
		collision.velocityY = -speed;
        collision.userData=this;
        collisionGroup.add(collision);
	}

	override function update(dt:Float) {
		time += dt;
		super.update(dt);
		collision.update(dt);
		if (time > 3) {
			die();
		}
	}

	override function render() {
		super.render();
        sprite.x = collision.x;
		sprite.y = collision.y;
	}

	override function destroy() {
		super.destroy();
        collision.removeFromParent();
        sprite.removeFromParent();
	}
}
