public var rainShader:CustomShader;

var rainTimer:Float = 0;
var shaderUpdateTimer:Float = 0;

public var rainSpeed:Float = 0.8;
public var rainTimeScale:Float = 5.0;

function create() {
    if (!Options.shaderQualityAllows(1)) {
        disableScript();
        return;
    }

    var highShaders:Bool = Options.shaderQualityAllows(2);
    rainShader = new CustomShader("rainShader");

    rainShader.cameraZoom = FlxG.camera.zoom;
    rainShader.flipY = true;

    rainShader.time = 0;
    rainShader.res = [FlxG.width, FlxG.height];

    rainShader.STARTING_LAYERS = 0;
    rainShader.LAYERS = highShaders ? 10 : 5;
    rainShader.pixely = false;
    rainShader.blurStrength = highShaders ? 0.7 : 0.0;
    rainShader.wobbleStrength = highShaders ? 0.07 : 0.035;

    camGame.addShader(rainShader);
}

function update(elapsed:Float) {
    if (rainShader == null) return;

    rainTimer += elapsed * rainSpeed;
    if (!Options.shaderQualityAllows(2)) {
        shaderUpdateTimer += elapsed;
        if (shaderUpdateTimer < 1 / 30)
            return;
        shaderUpdateTimer = 0;
    }

    rainShader.time = rainTimer * rainTimeScale;

    rainShader.cameraZoom = FlxG.camera.zoom;
}
