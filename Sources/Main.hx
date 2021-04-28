package;

import kha.System;
import com.framework.Simulation;
import states.MainState;

class Main {

    public static function main() {
        System.start({title: "Project", width: 1280, height: 720}, function (_) {        
            new Simulation(MainState,1280,720,1,0);
        });
    }
}
