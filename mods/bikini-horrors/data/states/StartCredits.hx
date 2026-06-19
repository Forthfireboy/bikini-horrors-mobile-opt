import haxe.Json;
import openfl.utils.Assets;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.FlxG;          // Explicit import just in case
import flixel.util.FlxTimer; // Explicit import just in case

var water:CustomShader = null;

var musicTitle:FlxText;
var musicNames:FlxText;
var artTitle:FlxText;
var artNames:FlxText;
var codeTitle:FlxText;
var codeNames:FlxText;
var chartTitle:FlxText;
var chartNames:FlxText;

var portrait:FlxSprite;
var fade:FlxSprite;
var bubbles:FlxSprite;

function create() {
    var rawJson:String = Assets.getText(Paths.json('config/tcards'));
    var creditsData = Json.parse(rawJson);
    var songName:String = PlayState.SONG.meta.name.toLowerCase(); 
    var data = Reflect.field(creditsData, songName);

    bgSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tcards/bg'));
    bgSprite.scale.set(0.7, 0.7);
    bgSprite.updateHitbox();
    bgSprite.screenCenter();
    add(bgSprite);

    guater = new FlxSprite(0, 0).loadGraphic(Paths.image('tcards/guater'));
    guater.scale.set(0.7, 0.7);
    guater.alpha = 0.3;
    guater.updateHitbox();
    guater.screenCenter();
    add(guater);

    if (Options.gameplayShaders) {
        water = new CustomShader("waterDistortion");
        water.strength = 0.5;
        guater.shader = water;
    }

    function createSection(label:String, field:Array<String>) {
        var namesStr:String = (field != null && field.length > 0) ? field.join("\n") : "";
        
        var t = new FlxText(0, 0, 0, label);
        t.setFormat(Paths.font("KrabbyPatty.otf"), 45, 0x4646fa, "center");
        t.updateHitbox();

        var n = new FlxText(0, 0, 0, namesStr);
        n.setFormat(Paths.font("KrabbyPatty.otf"), 80, 0x4646fa, "center");
        n.updateHitbox();

        var gap:Float = 20;
        var totalHeight:Float = t.height + gap + n.height;
        var initY:Float = (FlxG.height / 2) - (totalHeight / 2);

        t.y = initY;
        n.y = t.y + t.height + gap;

        t.screenCenter(FlxAxes.X);
        t.x -= 50;
        
        n.x = t.x + (t.width / 2) - (n.width / 2) + 35;
        t.angle = -10;
        n.angle = -10;
        t.alpha = 0;
        n.alpha = 0;
        
        add(t);
        add(n);

        return {title: t, names: n};
    }

    var musicData = createSection("MUSIC", data?.musicians);
    musicTitle = musicData.title;
    musicNames = musicData.names;

    var artData = createSection("ART", data?.artists);
    artTitle = artData.title;
    artNames = artData.names;

    var codeData = createSection("CODING", data?.coders);
    codeTitle = codeData.title;
    codeNames = codeData.names;

    var chartData = createSection("CHART", data?.charters);
    chartTitle = chartData.title;
    chartNames = chartData.names;

    portrait = new FlxSprite(0, 0).loadGraphic(Paths.image('tcards/' + songName));
    portrait.screenCenter();
    add(portrait);

    fade = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    add(fade);

    bubbles = new FunkinSprite(0, 0, Paths.image('tcards/bubbles'));
    bubbles.addAnim('idle', 'idle0', 30, true);
    bubbles.scale.set(1, 1);
    bubbles.antialiasing = true;
    bubbles.updateHitbox();
    bubbles.screenCenter();
    add(bubbles);

    FlxG.sound.playMusic(Paths.music('intros/' + songName), 1.0, false);
    FlxTween.tween(fade, {alpha: 0}, 0.6, {
        onComplete: function(_) {
            FlxTween.tween(fade, {alpha: 1}, 0.5, {startDelay: 1.5, onComplete: function(_) {
                portrait.alpha = 0;

                musicTitle.alpha = 1;
                musicNames.alpha = 1;
                FlxTween.tween(fade, {alpha: 0}, 0.4, {onComplete: function(_) {
                    
                    FlxTween.tween(musicTitle, {alpha: 0}, 0.4, {startDelay: 1.8});
                    FlxTween.tween(musicNames, {alpha: 0}, 0.4, {startDelay: 1.8});
                    
                    FlxTween.tween(artTitle, {alpha: 1}, 0.4, {startDelay: 2.2});
                    FlxTween.tween(artNames, {alpha: 1}, 0.4, {startDelay: 2.2, onComplete: function(_) {
                        
                        FlxTween.tween(artTitle, {alpha: 0}, 0.4, {startDelay: 1.8});
                        FlxTween.tween(artNames, {alpha: 0}, 0.4, {startDelay: 1.8});
                        
                        FlxTween.tween(codeTitle, {alpha: 1}, 0.4, {startDelay: 2.2});
                        FlxTween.tween(codeNames, {alpha: 1}, 0.4, {startDelay: 2.2, onComplete: function(_) {
                            
                            FlxTween.tween(codeTitle, {alpha: 0}, 0.4, {startDelay: 1.8});
                            FlxTween.tween(codeNames, {alpha: 0}, 0.4, {startDelay: 1.8});
                            
                            FlxTween.tween(chartTitle, {alpha: 1}, 0.4, {startDelay: 2.2});
                            FlxTween.tween(chartNames, {alpha: 1}, 0.4, {startDelay: 2.2, onComplete: function(_) {
                                
                                FlxG.sound.play(Paths.sound('bubbles'), 2); 
                                bubbles.playAnim('idle');

                                FlxTween.tween(fade, {alpha: 1}, 0.6, {startDelay: 1.5, onComplete: function(_) {
                                    new FlxTimer().start(1.0, function(tmr:FlxTimer) {
                                        // FIXED: Checking save data instead of publicArray
                                        if (FlxG.save.data.cutsceneToPlay != null && FlxG.save.data.cutsceneToPlay != "") {
                                            FlxG.switchState(new ModState("EnterSongCutscene"));
                                            return;
                                        }
                                        PlayState.switchToPlayState();
                                    });
                                }});
                            }});
                        }});
                    }});
                }});
            }});
        }
    });
    addMobilePad("NONE", "A");
}

var tottalTimer:Float = FlxG.random.float(100, 1000);
function update(elapsed:Float) {
    water?.time = (tottalTimer += elapsed);
    if (controls.ACCEPT || FlxG.keys.justPressed.SPACE) {
        // FIXED: Checking save data on manual skip too
        if (FlxG.save.data.cutsceneToPlay != null && FlxG.save.data.cutsceneToPlay != "") {
            FlxG.sound.music.stop();
            FlxG.switchState(new ModState("EnterSongCutscene"));
            return;
        }
        PlayState.switchToPlayState();
    }
}
