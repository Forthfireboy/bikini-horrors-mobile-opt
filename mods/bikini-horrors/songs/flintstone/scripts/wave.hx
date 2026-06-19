import openfl.filters.ShaderFilter;

var shaderer;
public var bgCam : FlxCamera;

function create(){
    bgCam = new FlxCamera();
    bgCam.bgColor = FlxColor.TRANSPARENT;

    FlxG.cameras.remove(camGame, false);
    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.add(bgCam, false);
    FlxG.cameras.add(camGame, true);
    FlxG.cameras.add(camHUD, false);
    camGame.bgColor = FlxColor.TRANSPARENT;
    shaderer = new CustomShader("holandesShader");

    shaderer.strength = 0;
    shaderer.amplitude = 0;
    shaderer.frequency = 8;
    shaderer.speed = 1.5;
    shaderer.tintAmount = 0;
    shaderer.tintColor = [0.08, 0.22, 0.10];
}

function postCreate()
{
    if (camGame.filters != null)
        bgCam.setFilters(camGame.filters.copy());
    bgCam.addShader(shaderer);
    bgCam.pixelPerfectRender = true;
}

var timer:Float = 0;

function update(elapsed:Float) 
{
    bgCam.scroll = camGame.scroll;
    bgCam.zoom = camGame.zoom;
    timer += elapsed;

    if (shaderer != null)
    {
        shaderer.time = timer;
    }else
     trace("notwork");
}

public function startWave(){
    FlxTween.tween(shaderer, {strength:1, amplitude: 0.03, tintAmount:0.9}, 3, {ease:FlxEase.quartInOut});
}