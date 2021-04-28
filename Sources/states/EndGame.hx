package states;

import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.helpers.Screen;
import com.gEngine.display.Text;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import states.GameState;

class EndGame extends State {

    override function load(resources:Resources) {
        var atlas=new JoinAtlas(512,512);
        atlas.add(new FontLoader("Kenney_Thick",20));
        resources.add(atlas);
    }

    override function init() {
        this.stageColor(0.5,0.5,0.5);
        
        lostText();
        scoreText();
        replayPrompt();
    }

    function lostText(){
        var text=new Text("Kenney_Thick");
        text.fontSize = 50;
        text.smooth=false;
        text.text="YOU LOST"; 
        text.x = Screen.getWidth()*0.5 - text.width()*0.5;
        text.y = Screen.getHeight()*0.5 - 60;
        stage.addChild(text);
    }

    function scoreText(){
        var text=new Text("Kenney_Thick");
        text.smooth=false;
        text.fontSize = 30;
        var score = Std.string(GlobalGameData.score);
        text.text='Score ' + score; 
        text.x = Screen.getWidth()*0.5 - text.width()*0.5;
        text.y = Screen.getHeight()*0.5 ;
        stage.addChild(text);
    }

    function replayPrompt(){
        var text=new Text("Kenney_Thick");
        text.fontSize = 40;
        text.smooth=false;
        text.text="Press Space to play again"; 
        text.x = Screen.getWidth()*0.5 - text.width()*0.5;
        text.y = Screen.getHeight()*0.5 + 200;
        stage.addChild(text);
    }
    
    override function update(dt:Float){
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
           this.changeState(new GameState());
        }
    }
}