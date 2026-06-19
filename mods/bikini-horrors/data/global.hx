import hxvlc.util.Handle;
import lime.graphics.Image;
//import funkin.backend.utils.WindowUtils;
import funkin.savedata.FunkinSave;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionType;
import flixel.addons.transition.TransitionData;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import funkin.backend.MusicBeatTransition;
import funkin.backend.utils.NdllUtil;
import funkin.game.PlayState;
import openfl.Lib;
import lime.app.Application;

if (FlxG.save.data.adUnlocked == null)
    FlxG.save.data.adUnlocked = false;

//FOR GENERAL STATE-TO-STATE COMUNICATION
static public var publicArray:Array<Dynamic> = [];

function new() {
    FlxG.save.data.cg ??= false;
    FlxG.save.data.mech ??= false;
    FlxG.save.data.priv ??= false;
    MusicBeatTransition.script = 'data/scripts/customTransitions';
    //window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('menus/icon'))));
    //WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function preStateSwitch() {
    if (FlxG.game._requestedState is TitleState) 
        FlxG.game._requestedState = new ModState("BHTitleState");
    if (FlxG.game._requestedState is MainMenuState) 
        FlxG.game._requestedState = new ModState("BHTitleState");
    if (FlxG.game._requestedState is FreeplayState){
        FlxG.game._requestedState = new ModState("VersionHandler");
    }
    
    FlxG.mouse.visible = false;
}

function postGameStart()
    FlxG.game._requestedState = new ModState('BHWarningState');


//function destroy() WindowUtils.winTitle = window.title = "Friday Night Funkin' - Codename Engine";


static function transparentFlxCamera(camera:FlxCamera) {
	if (camera != null) camera.bgColor = 0x00FF0000;
}

static public function shouldPlayPrisonHitNotification():Bool
{
    if (FlxG.save.data.storyStage == null) FlxG.save.data.storyStage = 0;
    if (FlxG.save.data.hasMetPrisoner == null) FlxG.save.data.hasMetPrisoner = false;

    var key:String = Std.string(FlxG.save.data.storyStage) + ":" + Std.string(FlxG.save.data.hasMetPrisoner);
    if (FlxG.save.data.lastPrisonHitNotifyKey == key)
        return false;

    FlxG.save.data.lastPrisonHitNotifyKey = key;
    FlxG.save.flush();
    return true;
}

static function tweenAlpha(object, targetAlpha:Float, duration:Float, easeFunc)
{
    if (object == null)
        return;

    if (duration <= 0)
        object.alpha = targetAlpha;
    else if (easeFunc != null)
        FlxTween.tween(object, {alpha: targetAlpha}, duration, {ease: easeFunc});
    else
        FlxTween.tween(object, {alpha: targetAlpha}, duration);
}

static function tweenNoteHudAlpha(note, targetAlpha:Float, duration:Float, easeFunc)
{
    if (note == null)
        return;

    var finalAlpha:Float = note.__baseAlpha * targetAlpha;
    if (duration <= 0)
        note.alpha = finalAlpha;
    else if (easeFunc != null)
        FlxTween.num(note.alpha, finalAlpha, duration, {ease: easeFunc}, function(value:Float) {
            note.alpha = value;
        });
    else
        FlxTween.num(note.alpha, finalAlpha, duration, null, function(value:Float) {
            note.alpha = value;
        });
}

static public function setHudArrowsAlpha(targetAlpha:Float, duration:Float = 0, easeFunc = null)
{
    var state = PlayState.instance;
    if (state == null || state.strumLines == null)
        return;

    for (strumLine in state.strumLines) {
        if (strumLine == null)
            continue;

        strumLine.extra.set("hudAlpha", targetAlpha);

        for (strum in strumLine.members)
            tweenAlpha(strum, targetAlpha, duration, easeFunc);

        if (strumLine.notes != null)
            for (note in strumLine.notes)
                tweenNoteHudAlpha(note, targetAlpha, duration, easeFunc);
    }
}

static public function checkStoryProgression()
{
    if (FlxG.save.data.unlockedV2 == null) FlxG.save.data.unlockedV2 = false; 
    if (FlxG.save.data.lastSeenStage == null) FlxG.save.data.lastSeenStage = 0;
    if (FlxG.save.data.hasMetPrisoner == null) FlxG.save.data.hasMetPrisoner = false;
    if (FlxG.save.data.clearedSongs == null) FlxG.save.data.clearedSongs = [];
    if (FlxG.save.data.megaMortalMode == null) FlxG.save.data.megaMortalMode = false;
    var act1:Array<String> = ["vash-a-morir", "paracetamol", "ups-me-caigo", "rent-due", "rumbeling"];
    var act2:Array<String> = ["powerscaling", "barnacles", "steamunlocked", "made-in-china", "flintstone"];
    var act3:Array<String> = ["pool-parti"];
    var act4:Array<String> = ["mega-mortal-madness"];
    var act5:Array<String> = [
        "i-am-back",
        "wordle",
        "fertility",
        "so-retro",
        "no-phone-zone",
        "chromosome",
        "daddatel",
        "try-and-trong",          
        "aloha-aloha",
        "unheard",
        "go-to-eat",
        "pneumonoultramicroscopicsilicovolcanoconiosis",
        "carmaland-retake",
        "pop-a-corn",
        "spotting",
        "kaka",
        "ayuda-por-favor",
        "la-playa",
        "for-you-someday"
    ];

    var clearedList:Array<String> = FlxG.save.data.clearedSongs;
    var currentStage:Int = 0;

    var milestone1Count:Int = 0;
    for (song in act1) {
        if (clearedList.contains(song)) milestone1Count++;
    }

    var milestone2Count:Int = 0;
    for (song in act2) {
        if (clearedList.contains(song)) milestone2Count++;
    }

    var milestone3Count:Int = 0;
    for (song in act3) {
        if (clearedList.contains(song)) milestone3Count++;
    }

    var milestone4Count:Int = 0;
    for (song in act4) {
        if (clearedList.contains(song)) milestone4Count++;
    }

    var milestone5Count:Int = 0;
    for (song in act5) {
        if (clearedList.contains(song)) milestone5Count++;
    }

    if (milestone1Count >= 5 && milestone2Count < 5) {
        currentStage = 1;
    } else if (milestone2Count >= 5 && milestone3Count < 1) {
        currentStage = 2;
    } else if (milestone3Count == 1 && milestone4Count < 1){
        FlxG.save.data.megaMortalMode = true;
        currentStage = 2;
        FlxG.save.data.lastSeenStage = 2;
    } else if (milestone4Count >= 1 && milestone5Count < act5.length) {
        FlxG.save.data.megaMortalMode = false;
        FlxG.save.data.unlockedV2 = true;
    } else if (milestone5Count >= act5.length - 1 && !FlxG.save.data.clearedSongs.contains("corre-corre-que-te-pillo")){
        FlxG.save.data.correCorreMode = true;
    } else if (FlxG.save.data.clearedSongs.contains("corre-corre-que-te-pillo")) {
        FlxG.save.data.correCorreMode = false;
    }

    FlxG.save.data.storyStage = currentStage;
    FlxG.save.flush();

    if (currentStage > FlxG.save.data.lastSeenStage || !FlxG.save.data.hasMetPrisoner) {
        trace("NEW STORY ENCOUNTER UNLOCKED!");
        return true;
    }
    return false;
}
