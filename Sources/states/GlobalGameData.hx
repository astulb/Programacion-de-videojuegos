package states;

import com.gEngine.display.Layer;

// import gameObjects.Player;
// import com.gEngine.display.Layer;

class GlobalGameData {
	static public var simulationLayer:Layer;
	static public var backgroundLayer:Layer;
	// static public var player:Player;

    static public var score:Int = 0;

	static public function destroy() {
		// player=null;
		simulationLayer=null;
		backgroundLayer=null;
	}
}
