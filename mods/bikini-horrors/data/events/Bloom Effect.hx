// CREDITS TO LUNAR AND NEX FOR THESE SHADERS, BLOOM, SATURATION ETC.

public var bloom:CustomShader = null;
var bloomOnHud:Bool = false;

function create() {
    if(!Options.shaderQualityAllows(1)) {
        disableScript();
        return;
    }

    var highShaders:Bool = Options.shaderQualityAllows(2);
    bloom = new CustomShader("bloom");
    bloom.size = 0; bloom.brightness = 1;
    bloom.directions = highShaders ? 6 : 4;
    bloom.quality = highShaders ? 6 : 4;
    FlxG.camera.addShader(bloom);
    bloomOnHud = highShaders;
    if (bloomOnHud)
        camHUD.addShader(bloom);
}

var bloomTween:FlxTween = null;
var curbloom:Float = 1;

function normalizeBloomSongName(value:String):String {
    if (value == null)
        return "";

    return value.toLowerCase().split(" ").join("").split("-").join("").split("_").join("");
}

function isBloomSong(song:String):Bool {
    var target:String = normalizeBloomSongName(song);
    var songName:String = PlayState.SONG == null || PlayState.SONG.meta == null ? "" : PlayState.SONG.meta.name;
    var songId:String = PlayState.instance == null ? "" : PlayState.instance.curSongID;

    return normalizeBloomSongName(songName) == target || normalizeBloomSongName(songId) == target;
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Bloom Effect") {
        if (params[0] == false)
            setBloom(params[1]);
        else {
            if (bloomTween != null) bloomTween.cancel();
            var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);

            bloomTween = FlxTween.num(curbloom, params[1], ((Conductor.crochet / 4) / 1000) * params[2], 
            {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {setBloom(val);});
        }
    }
}

function setBloom(bloom_effect:Float) {
    if (bloom == null) return;

    if (bloom_effect <= 1) {
        bloom.size = 0;
        bloom.brightness = 1;
        curbloom = bloom_effect;
        return;
    }

    var highShaders:Bool = Options.shaderQualityAllows(2);
    var fertilityMedium:Bool = !highShaders && isBloomSong("fertility");
    var effect:Float = Math.max(bloom_effect, 1);
    if (highShaders)
        effect = Math.min(effect, 2.6);
    else if (fertilityMedium)
        effect = Math.min(effect, 1.85);
    else
        effect = Math.min(effect, 2.25);

    var bloomAmount:Float = Math.max(effect - 1, 0);
    bloom.size = bloomAmount * (highShaders ? 2.55 : (fertilityMedium ? 1.75 : 2.35));
    bloom.brightness = highShaders ? 1 + Math.min(bloomAmount, 1.6) * 0.34 : (fertilityMedium ? 1 + Math.min(bloomAmount, 0.85) * 0.22 : Math.max(Math.min(effect, 1.45), 1));

    curbloom = bloom_effect;
}
