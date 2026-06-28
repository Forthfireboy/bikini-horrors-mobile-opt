// Script by bctix
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import flixel.text.FlxText.FlxTextAlign;

var lyricsConfig = {
    xOffset: 0,
    yOffset: 0,
    color: FlxColor.WHITE,
    borderColor: FlxColor.BLACK,
    font: "KrabbyPatty.otf",
    size: 34,
    borderSize: 2,
    textSpaceMovementMult: 1, // Multiplier for how far the text history moves. make it -1 to move down
    showHistory: true
}

var textGroup:FlxTypedGroup;
var textPool:Array<FlxText> = [];
var activeTexts:Array<FlxText> = [];
var fontCache:Map<String, String> = [];
var maxHistoryTexts:Int = 4;

function create()
{
    textGroup = new FlxTypedGroup();
    add(textGroup);
    var fontPath = getFont();
    for (i in 0...(maxHistoryTexts + 1)) {
        var text = createLyricText();
        text.setFormat(fontPath, lyricsConfig.size, lyricsConfig.color, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, lyricsConfig.borderColor);
        text.visible = false;
        text.active = false;
        text.alpha = 0;
        textPool.push(text);
    }
}

function onEvent(eventEvent) {
    if(eventEvent.event.name != "Lyrics") return;
    // trace(eventEvent.event.params);
    switch(eventEvent.event.params[0]) {
        case "Add Text":
            addText(eventEvent.event.params[1]);

        case "Force remove all text":
            killText();

        case "Set Color":
            lyricsConfig.color = eventEvent.event.params[2];

        case "Set Border Color":
            lyricsConfig.borderColor = eventEvent.event.params[2];

        case "Set Font":
            lyricsConfig.font = eventEvent.event.params[1];
            getFont();

        case "Set Size":
            lyricsConfig.size = eventEvent.event.params[1];

        case "Enable text history (On, Off)":
            lyricsConfig.showHistory = eventEvent.event.params[3];
        case "Change text offset":
            lyricsConfig.xOffset = Std.int(eventEvent.event.params[1].split(",")[0]);
            lyricsConfig.yOffset = Std.int(eventEvent.event.params[1].split(",")[1]);
            
    }
}

function addText(setText)
{
    var oldTexts:Array<FlxText> = activeTexts.copy();
    var spaceToMove = !camHUD.downscroll ? lyricsConfig.size : -1 * lyricsConfig.size;
    spaceToMove *= lyricsConfig.textSpaceMovementMult;

    for(i in oldTexts)
    {
        if (i == null) continue;
        FlxTween.cancelTweensOf(i);

        if(lyricsConfig.showHistory)
        {
            FlxTween.tween(i, {alpha: i.alpha - 0.7, y: i.y - spaceToMove}, 0.25, {ease: FlxEase.cubeOut, onComplete: function(t){
                if(i.alpha <= 0.05)
                    recycleText(i);
            }});
        } else {
            recycleText(i);
        }
        
    }

    trimHistory();

    var text = getTextFromPool();
    text.setFormat(getFont(), lyricsConfig.size, lyricsConfig.color, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, lyricsConfig.borderColor);
    text.borderSize = lyricsConfig.borderSize;
    text.text = setText;
    text.alpha = 1;
    text.visible = true;
    text.active = true;
    text.cameras = [camHUD];
    text.scrollFactor.set();
    text.y = 500;
    text.screenCenter(FlxAxes.X);
    text.x += lyricsConfig.xOffset;
    text.y += lyricsConfig.yOffset;

    textGroup.add(text);
    activeTexts.push(text);
    trimHistory();
}

function getFont()
{
    if (fontCache.exists(lyricsConfig.font))
        return fontCache.get(lyricsConfig.font);

    var resolved:String = null;
    var fontName:String = Std.string(lyricsConfig.font);
    var candidates:Array<String> = [];

    if (StringTools.endsWith(fontName, ".ttf") || StringTools.endsWith(fontName, ".otf")) {
        candidates.push(fontName);
    } else {
        candidates.push(fontName + ".otf");
        candidates.push(fontName + ".ttf");
        candidates.push(fontName);
    }

    candidates.push("KrabbyPatty.otf");

    for (candidate in candidates) {
        var path = Paths.font(candidate);
        if (Assets.exists(path)) {
            resolved = path;
            break;
        }
    }

    if (resolved == null)
        resolved = Paths.font("KrabbyPatty.otf");

    fontCache.set(lyricsConfig.font, resolved);
    return resolved;
}

function getTextFromPool():FlxText
{
    if (textPool.length > 0) {
        var text = textPool.pop();
        text.revive();
        return text;
    }

    var text = new FlxText(0, 500);
    return setupLyricText(text);
}

function createLyricText():FlxText
{
    return setupLyricText(new FlxText(0, 500));
}

function setupLyricText(text:FlxText):FlxText
{
    text.cameras = [camHUD];
    text.scrollFactor.set();
    text.antialiasing = true;
    return text;
}

function recycleText(text:FlxText):Void
{
    if (text == null) return;

    FlxTween.cancelTweensOf(text);
    textGroup.remove(text, true);
    activeTexts.remove(text);
    text.text = "";
    text.visible = false;
    text.active = false;
    text.alpha = 0;
    textPool.push(text);
}

function trimHistory():Void
{
    while (activeTexts.length > maxHistoryTexts) {
        recycleText(activeTexts[0]);
    }
}

function killText()
{
    for(i in activeTexts.copy())
    {
        if (i == null) continue;
        FlxTween.cancelTweensOf(i);
        FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut, onComplete: function(t){
            recycleText(i);
        }});
    }
}

function destroy()
{
    for(i in activeTexts.copy())
        recycleText(i);

    for(i in textPool) {
        if (i != null)
            i.destroy();
    }
    textPool = [];
    activeTexts = [];
}
