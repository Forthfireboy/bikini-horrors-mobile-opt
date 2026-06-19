//Script by umbra

var active:Bool = false;
var starvedCamera:FlxCamera;
var starvedSprite:FlxSprite;
var starvedSound:FlxSound;
static var curBotplay:Bool = false;
var voiceoverPath:String = "";

function postCreate() {
    if (active) {
        var songName:String = "";
        
        songName = SONG.meta.name.toLowerCase();
        
        voiceoverPath = 'songs/' + songName + '/song/Voiceover.ogg';
        
        setupVoiceover(voiceoverPath);
        activateBotplay();
    }

    GameOverSubstate.script = "data/scripts/customGameover";
}

function stepHit(curStep:Int) {
    if (curStep == 0) {
		loadAndPlayVoiceover(voiceoverPath);
	}
}

function setupVoiceover(path:String) {
    starvedCamera = new FlxCamera();
    starvedCamera.bgColor = 0x00000000;
    FlxG.cameras.add(starvedCamera, false);
    
    starvedSprite = new FlxSprite();
    starvedSprite.loadGraphic(Paths.image('voiceover'));
    starvedSprite.x = FlxG.width - starvedSprite.width - 10;
    starvedSprite.y = 10;
    starvedSprite.scrollFactor.set(0, 0);
    starvedSprite.cameras = [starvedCamera];
    
    PlayState.instance.add(starvedSprite);
}

function loadAndPlayVoiceover(path:String) {
    starvedSound = FlxG.sound.load(Paths.getPath(path));
    
    if (starvedSound != null) {
        starvedSound.volume = 1.0;
        starvedSound.play();
    }
}

function activateBotplay() {
    curBotplay = true;
    
    if (PlayState.instance != null && PlayState.instance.player != null) {
        PlayState.instance.player.cpu = true;
    }
}

function update(elapsed:Float) {
    if (active && starvedSprite != null) {
        starvedSprite.x = FlxG.width - starvedSprite.width - 10;
        starvedSprite.y = 10;
        
        if (PlayState.instance != null && PlayState.instance.player != null && curBotplay) {
            if (PlayState.instance.player.cpu == false) {
                PlayState.instance.player.cpu = true;
            }
        }
    }
}

function destroy() {
    
    if (starvedSprite != null) {
        starvedSprite.destroy();
    }
    
    if (starvedSound != null) {
        starvedSound.destroy();
    }
}