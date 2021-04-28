package states;

import com.gEngine.helpers.Screen;
import com.gEngine.helpers.RectangleDisplay;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.Text;
import gameObjects.Bullet;
import com.collision.platformer.CollisionEngine;
import com.collision.platformer.ICollider;
import gameObjects.Enemy;
import com.collision.platformer.CollisionGroup;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import gameObjects.Player;
import com.framework.utils.State;
import com.gEngine.display.Layer;


class GameState extends State {
    var player:Player;
    var enemyCollision:CollisionGroup;
    var scoreText:Text;

    var timeForSpawn:Float = 7;
    var timeForDifficultyIncrease:Float = 0;
    var spawnTimer:Float = 3;

    override function load(resources:Resources){
        var atlas=new JoinAtlas(512,512);
        atlas.add(new FontLoader("Kenney_Thick",20));
        resources.add(atlas);
        resources.add(new ImageLoader("cannon"));
        resources.add(new ImageLoader("bullet"));
        resources.add(new ImageLoader("enemy"));
    }

    override function init(){
        var backgroundLayer = new Layer();
        var simulationLayer = new Layer();
		stage.addChild(backgroundLayer);
		stage.addChild(simulationLayer);
		GlobalGameData.simulationLayer = simulationLayer;
		GlobalGameData.backgroundLayer = backgroundLayer;
        GlobalGameData.score = 0;

		player = new Player(GameConfig.windowsWidth*0.5, GameConfig.windowsHight-100);
		addChild(player);

        enemyCollision = new CollisionGroup();

        initScoreText();

        drawFloor();
    }

    function drawFloor(){
        var display = new RectangleDisplay();
		display.setColor(0, 255, 0);
		display.scaleX = Screen.getWidth();
		display.scaleY = GameConfig.floorHeight;
		display.x = 0;
		display.y = Screen.getHeight() - display.scaleY;
        display.alpha = 0.5;
        GlobalGameData.backgroundLayer.addChild(display);
    }

    function initScoreText(){
        scoreText=new Text("Kenney_Thick");
        scoreText.smooth=false;
        scoreText.fontSize = 30;
        scoreText.x = 50;
        scoreText.y = 50 ;
        scoreText.text = 'Score 0';
        stage.addChild(scoreText);
    }

    override function update(dt:Float) {
		super.update(dt);
        detectCollisions();
        enemySpawner(dt);
	}

    function enemySpawner(dt:Float){
        timeForDifficultyIncrease += dt;
        spawnTimer += dt;
        if(timeForDifficultyIncrease > 20 && timeForSpawn >3){
            timeForSpawn--;
            timeForDifficultyIncrease = 0;
        }
        if(spawnTimer >= timeForSpawn){
            spawnEnemy();
            spawnTimer = 0;
        }	
    }

    function spawnEnemy(){
        var enemy = new Enemy(randomRange(Screen.getWidth()-GameConfig.screenMargin, GameConfig.screenMargin), GameConfig.screenMargin, enemyCollision);
        addChild(enemy);
    }

    function detectCollisions(){
        CollisionEngine.overlap(player.collision, enemyCollision, playerVsEnemy);
		CollisionEngine.overlap(player.bulletsCollision, enemyCollision, bulletVsEnemy);
    }

    function playerVsEnemy(playerC:ICollider, enemyC:ICollider) {
        changeState(new EndGame());
	}

	function bulletVsEnemy(bulletC:ICollider, enemyC:ICollider) {
        var enemy:Enemy= enemyC.userData;
		if(enemy.currentSize > 1){
            var first = new Enemy(enemy.collision.x, enemy.collision.y, enemyCollision, 1, enemy.currentSize-1);
            var second = new Enemy(enemy.collision.x, enemy.collision.y, enemyCollision, -1, enemy.currentSize-1);
            addChild(first);
		    addChild(second);
        }
		enemy.die();
		var bullet:Bullet=cast bulletC.userData;
		bullet.die();
        updateScore();
	}

    function updateScore(){
        GlobalGameData.score += GameConfig.scorePerEnemy;
        var score = Std.string(GlobalGameData.score);
        scoreText.text='Score ' + score; 
    }

    function randomRange(max:Int, min:Int = 0){
        return Math.floor(Math.random() * (1 + max - min)) + min;
    }
}