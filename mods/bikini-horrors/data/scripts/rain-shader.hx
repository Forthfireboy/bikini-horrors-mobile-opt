public var rainShader:CustomShader;

var rainTimer:Float = 0;

public var rainSpeed:Float = 0.8;
public var rainTimeScale:Float = 5.0;

function create() {
    rainShader = new CustomShader("rainShader");

    rainShader.cameraZoom = FlxG.camera.zoom;
    rainShader.flipY = true;

    rainShader.time = 0;
    rainShader.res = [FlxG.width, FlxG.height];

    rainShader.STARTING_LAYERS = 0;
    rainShader.pixely = false;
    rainShader.blurStrength = 0.7;
    rainShader.wobbleStrength = 0.07;

    camGame.addShader(rainShader);
}

function update(elapsed:Float) {
    rainTimer += elapsed * rainSpeed;

    rainShader.time = rainTimer * rainTimeScale;

    rainShader.cameraZoom = FlxG.camera.zoom;
}