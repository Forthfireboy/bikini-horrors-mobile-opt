public var snowShader:CustomShader;
public var particleSprite:FunkinSprite;
public var snowShader2:CustomShader;

var initIndex:Int = null;
var snowRect:Array<Float> = [1000, 500, 180, 220];
var snowShaders:Array<CustomShader> = [];
var shaderUpdateTimer:Float = 0;

function create() {
    if (!Options.shaderQualityAllows(1)) {
        disableScript();
        return;
    }

    var highShaders:Bool = Options.shaderQualityAllows(2);
    var shaderCount:Int = highShaders ? 2 : 1;
    for (i in 0...shaderCount) {
        var newShader:CustomShader = new CustomShader("snow");
        newShader.cameraZoom = FlxG.camera.zoom; newShader.flipY = true;
        newShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
        newShader.time = 0; newShader.res = [FlxG.width, FlxG.height];
        newShader.LAYERS = highShaders ? (i == 0 ? 14 : 13) : 7;
        newShader.DEPTH = highShaders ? (i == 0 ? 1.2 : 1.5) : 1.1;
        newShader.WIDTH = highShaders ? .13 : .1;
        newShader.SPEED = i == 0 ? .6 : .3;
        newShader.STARTING_LAYERS = highShaders ? (i == 0 ? 7 : 1) : 3;
        newShader.snowMeltRect = snowRect; 
        newShader.snowMelts = true; newShader.pixely = false;
        newShader.BRIGHT = 0;
        newShader.noiseStrength = highShaders ? 0.4 : 0.0;

        if (i == 0) snowShader = newShader;
        else snowShader2 = newShader;
        snowShaders.push(newShader);
    }
}

public var snowSpeed:Float = 1;
public var tottalTimer:Float = FlxG.random.float(100, 1000);
function update(elapsed:Float) {
    if (snowShaders.length <= 0) return;

    tottalTimer += elapsed*snowSpeed;
    if (!Options.shaderQualityAllows(2)) {
        shaderUpdateTimer += elapsed;
        if (shaderUpdateTimer < 1 / 30)
            return;
        shaderUpdateTimer = 0;
    }

    for (shader in snowShaders) {
        if (shader == null) continue;
        shader.time = tottalTimer*3;

        shader.cameraZoom = FlxG.camera.zoom;
        shader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    }
}
