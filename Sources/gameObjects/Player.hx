package gameObjects;

import com.gEngine.helpers.Screen;
import states.GlobalGameData;
import com.gEngine.display.Sprite;
import states.GameConfig;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import kha.input.KeyCode;
import com.framework.utils.Input;
import kha.math.FastVector2;
import com.framework.utils.Entity;

class Player extends Entity {
	public var collision:CollisionBox;
	public var bulletsCollision:CollisionGroup;

    //Display properties
    var sprite:Sprite;
    var displayScale = 0.15;
    private var spriteW = 0;
    private var spriteH = 0;

	var speed:Float = GameConfig.playerSpeed;
	var facingDir:FastVector2 = new FastVector2(1, 0);
    var shotCooldown:Float = 0.14;
    var lastShotFired:Float = 0;

	public function new(x:Float, y:Float) {
		super();
        sprite = new Sprite("cannon");
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
		collision.x = x;
		collision.y = y;
		collision.dragX = 0.3;
		collision.dragY = 0.3;

		bulletsCollision=new CollisionGroup();
	}

	override public function update(dt:Float) {
		
		updatePlayerMovement();
        lastShotFired+=dt;
		if (Input.i.isKeyCodePressed(KeyCode.X) && lastShotFired>shotCooldown) {
			var bullet:Bullet = new Bullet(collision.x + collision.width * 0.5, collision.y, bulletsCollision);
			addChild(bullet);
            lastShotFired = 0;
		}

		collision.update(dt);
		super.update(dt);
	}

	inline function updatePlayerMovement() {
		var dir:FastVector2 = new FastVector2();
		if (Input.i.isKeyCodeDown(KeyCode.Left) && collision.x > GameConfig.screenMargin) {
			dir.x += -1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.Right) && collision.x + spriteW < GameConfig.windowsWidth - GameConfig.screenMargin) {
			dir.x += 1;
		}
		if (dir.length != 0) {
			var finalVelocity = dir.mult(speed);
			collision.velocityX = finalVelocity.x;
		}
	}

	override function render() {
		super.render();
        sprite.x = collision.x;
		sprite.y = collision.y;
	}

	override function destroy() {
		super.destroy();
        sprite.removeFromParent();
	}
}
