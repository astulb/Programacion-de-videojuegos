package gameObjects;

import com.gEngine.helpers.Screen;
import com.gEngine.display.Sprite;
import states.GameConfig;
import com.collision.platformer.CollisionGroup;
import states.GlobalGameData;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Enemy extends Entity {
    public var collision:CollisionBox;
	var velocityY:Float=0;
	var velocityX:Float=400;
    public var currentSize:Int = 3;
	var maxYVelocity:Float = 900;
    
    //Display properties
    var sprite:Sprite;
	var spriteRadius:Float;
    var displayScale = 0.5;
    private var spriteW = 0;
    private var spriteH = 0;

	//Parameter "size" defines the size state of the enemy, 3 being the normal starting size.
	public function new(x:Float, y:Float, collisionGroup:CollisionGroup, xDirection:Int=1, size:Int=3) {
		super();
		currentSize = size;
		displayScale = 0.07 * currentSize;
		maxYVelocity = 475 + 400*(currentSize*0.33);
		velocityX *= xDirection;

        sprite = new Sprite("enemy");
        spriteW = Std.int(sprite.width()*displayScale);
        spriteH = Std.int(sprite.height()*displayScale);
        sprite.x = x;
		sprite.y = y;
        sprite.scaleX = displayScale;
        sprite.scaleY = displayScale;
		spriteRadius = sprite.width()*displayScale*0.5;
        GlobalGameData.simulationLayer.addChild(sprite);

		collision = new CollisionBox();
		collision.width = spriteW;
		collision.height = spriteH;
		collision.x = x - (spriteW * 0.5);
		collision.y = y - (spriteH * 0.5);
		//collision.velocityY = speed;
        collision.userData=this;
        collisionGroup.add(collision);
	}

	var signX:Int=1;
    var signY:Int=1;
	override function update(dt:Float) {

		if(velocityY < maxYVelocity){
			velocityY += GameConfig.gravityValue*dt;
		}
		else{
			velocityY = maxYVelocity;
		}
		
    	collision.x += velocityX*dt*signX;
    	collision.y += velocityY*dt;

       	if(collision.x+ spriteW >= Screen.getWidth() || collision.x <= 0){
           signX *= -1;
       	}

    	if(collision.y + spriteH + GameConfig.floorHeight>= Screen.getHeight()){
			velocityY = -maxYVelocity;
        }
        
        super.update(dt);
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