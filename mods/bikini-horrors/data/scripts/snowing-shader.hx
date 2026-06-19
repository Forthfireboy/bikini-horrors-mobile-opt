public var snowShader:CustomShader;
public var particleSprite:FunkinSprite;
public var snowShader2:CustomShader;

var initIndex:Int = null;
var snowRect:Array<Float> = [1000, 500, 180, 220];

function create() {
    for (i in 0...2) {
        var newShader:CustomShader = new CustomShader("snow");
        newShader.cameraZoom = FlxG.camera.zoom; newShader.flipY = true;
        newShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
        newShader.time = 0; newShader.res = [FlxG.width, FlxG.height];
        newShader.LAYERS = i == 0 ? 14 : 14-1; newShader.DEPTH = i == 0 ? 1.2 : 1.5;
        newShader.WIDTH = .13; newShader.SPEED = i == 0 ? .6 : .3;
        newShader.STARTING_LAYERS = i == 0 ? 7 : 1;
        newShader.snowMeltRect = snowRect; 
        newShader.snowMelts = true; newShader.pixely = false;
        newShader.BRIGHT = 0;

        if (i == 0) snowShader = newShader;
        else snowShader2 = newShader;
    }
}

public var snowSpeed:Float = 1;
public var tottalTimer:Float = FlxG.random.float(100, 1000);
function update(elapsed:Float) {
    tottalTimer += elapsed*snowSpeed;
    for (shader in [snowShader, snowShader2]) {
        shader.time = tottalTimer*3;

        shader.cameraZoom = FlxG.camera.zoom;
        shader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    }
}