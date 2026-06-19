import flixel.FlxCamera;

var dialogueScript = importScript("data/scripts/DialogueManager");
var dialogue;
var water:CustomShader = null;
var gameCam:FlxCamera = new FlxCamera();

var totalTime:Float = 0;

function create() {
    checkStoryProgression();

    trace(FlxG.save.data.lastSeenStage);
    
    FlxG.sound.playMusic(Paths.music('prison/me_importa_dos_cominos'), 1.0, true);
    water = new CustomShader("waterDistortion");
    water.strength = 0.1;
    gameCam.addShader(water);
    gameCam.bgColor = 0x00000000;
    FlxG.cameras.add(gameCam, true);
    var figure = new FunkinSprite(0, 0, Paths.image("menus/prison/horror_ojos"));
    figure.addAnim("idle", "idle", 12, false);
    figure.addAnim("serious", "serious", 12, false);
    figure.addAnim("vicious", "vicious", 12, false);
    figure.addAnim("curious", "curious", 12, false);
    figure.addAnim("bored", "bored", 12, false);
    add(figure);
    figure.scale.x = 0.7;
    figure.scale.y = 0.7;
    figure.updateHitbox();
    figure.screenCenter();
    figure.y -= 80;
    
    bars = new FlxSprite(0, 0);
    bars.loadGraphic(Paths.image("menus/prison/barrotes"));
    bars.scale.x = 0.67;
    bars.scale.y = 0.67;
    bars.updateHitbox();
    bars.screenCenter();
    add(bars);

    hands = new FlxSprite(0, 0);
    hands.loadGraphic(Paths.image("menus/prison/manos"));
    hands.scale.x = 0.67;
    hands.scale.y = 0.67;
    hands.updateHitbox();
    hands.screenCenter();
    hands.alpha = 0;
    add(hands);
    
    vignette = new FlxSprite(0, 0);
    vignette.loadGraphic(Paths.image("menus/prison/vignette"));
    vignette.scale.x = 0.67;
    vignette.scale.y = 0.67;
    vignette.updateHitbox();
    vignette.screenCenter();
    add(vignette);

    dialogue = dialogueScript.call("newDialogueManager", ["prison", figure, hands,
    {
        textboxGraphic: "menus/prison/textbox",
        textOffsetY: 70,
        enterTime: 0.6,
        exitTime: 0.5,
        startDelay: 0.8,
        stopWhenFinish : false,
        hiddenOffset: 200,
        typeDelay: 0.04,
        animType : "slide"
    }
    ]);
    
    if (dialogue != null) {
        if (dialogue.textBox != null) add(dialogue.textBox);
        if (dialogue.display != null) add(dialogue.display);
        dialogue.textBox.camera = gameCam;
        dialogue.display.camera = gameCam;
    } else {
        trace("Error: Dialogue object is null");
        return;
    }
    chooseDialogue(dialogue);
    figure.alpha = 0;
}

function update(elapsed:Float) {
    totalTime += elapsed;
    water?.time = (totalTime);
    if (dialogue != null && !dialogue.finished) {
        dialogue.update(dialogue, elapsed);
    }
    if (dialogue.finished) {
        FlxG.save.flush();
        FlxG.switchState(new ModState("BHTitleState"));
    }
}

function chooseDialogue(dialogue:Dynamic){
    var current = FlxG.save.data.storyStage;
    var seen = FlxG.save.data.lastSeenStage;

    if (!FlxG.save.data.hasMetPrisoner){
        dialogue.yap(dialogue, "first_greeting");
        FlxG.save.data.hasMetPrisoner = true;
        return;
    }

    if (current > seen) {
        dialogue.yap(dialogue, "after_" + current);
        
        FlxG.save.data.lastSeenStage = current;
    } 
    else {
        dialogue.yap(dialogue, "no_more_" + current);
    }
}

function resetSave() {
    FlxG.save.erase(); 
    FlxG.save.data.hasMetPrisoner = false;
    FlxG.save.data.beatTheGame = false;
    FlxG.save.data.timesInteracted = 0;
    FlxG.save.data.lastSeenStage = 0;
    FlxG.save.data.storyStage = 0;
    
    FlxG.save.flush();
    
    trace("A tomar por culo");
}
