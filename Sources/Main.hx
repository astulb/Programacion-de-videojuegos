package;

import states.GameConfig;
import kha.System;
import com.framework.Simulation;
import states.MainState;
import states.GameState;

class Main {

    public static function main() {
        System.start({title: "Project", width: GameConfig.windowsWidth, height: GameConfig.windowsHight}, function (_) {        
            new Simulation(MainState,GameConfig.windowsWidth,GameConfig.windowsHight,1,0);
        });
    }
}
