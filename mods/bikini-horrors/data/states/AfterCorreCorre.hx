import lime.system.System;
var dialogue;
var dialogueScript = importScript("data/scripts/DialogueManager");
function createPhanes()
{
    FlxG.sound.play(Paths.music("goodbye"), 0.75);

    phanes = new FunkinSprite(
        900,
        340,
        Paths.image("menus/v2freeplay/phanes_freeplay")
    );

    phanes.addAnim("idle", "idle", 24, true);
    phanes.addAnim("feelings", "feelings", 24, true);
    phanes.addAnim("sad_talk_left", "talk_sad_left", 24, true);
    phanes.addAnim("cool", "cool", 24, true);
    phanes.addAnim("default_talk", "default_talk", 24, true);
    phanes.addAnim("sad_talk", "triste_talk", 24, true);
    phanes.addAnim("up_talk", "up_talk", 24, true);
    phanes.addAnim("left_talk", "left_talk", 24, true);
    phanes.addAnim("excited", "excited", 24, true);
    phanes.addAnim("wave", "wave", 24, true);
    phanes.addAnim("sad_wave", "sad_wave", 24, true);
    phanes.addAnim("worried", "worried", 24, true);
    phanes.addAnim("paper", "paper", 24, true);
    phanes.addAnim("look_paper", "look_paper", 12, false);
    phanes.addAnim("playa", "playa", 4, true);
    phanes.addAnim("wait", "wait", 24, true);

    add(phanes);

    phanes.antialiasing = true;
    phanes.scale.set(0.75, 0.75);

    phanes.addOffset("default_talk", 0, 6);
    phanes.addOffset("left_talk", 0, 6);
    phanes.addOffset("sad_talk", 0, 6);
    phanes.addOffset("wave", 150, 230);
    phanes.addOffset("sad_wave", 150, 230);
    phanes.addOffset("uh", 30, 0);
    phanes.addOffset("cool", 100, 0);
    phanes.addOffset("excited", 0, -50);
    phanes.addOffset("wait", 50, 50);

    phanes.playAnim("wave", true);
}

function createDialogue()
{
    dialogue = dialogueScript.call(
        "newDialogueManager",
        [
            "interludes/v2_v3",
            phanes,
            null,
            {
                yVisibleOffset: -25,
                textboxGraphic: "menus/v2freeplay/textbox",
                boxYVisible: FlxG.height - 215,
                boxYHidden: FlxG.height + 200,
                textPaddingX: 50,
                textAlign: "left",
                animType: "slide",
                stopWhenFinish: false,
                textColor: 0xFFC000B6
            }
        ]
    );

    if (dialogue == null)
    {
        trace("Dialogue object is null");
        return;
    }

    if (dialogue.textBox != null)
        add(dialogue.textBox);

    if (dialogue.display != null)
        add(dialogue.display);
}

function update(elapsed:Float){
    if (dialogue != null && !dialogue.finished)
    {
        dialogue.update(dialogue, elapsed);
        if (dialogue.finished)
        {
            if (dialogueActive)
            {
                dialogueActive = false;

                phanes.playAnim("idle", true);
            }
        }
    }

    if (dialogue.finished) {
        FlxG.save.data.megaMortalMode = false;
        FlxG.save.data.unlockedV2 = true;
        FlxG.save.flush();
        FlxG.switchState(new ModState("BHTitleState"));
        System.openURL("https://hidding-penumbra.itch.io/underguater-moto");
    }
}

function postCreate(){
    
    createPhanes();
    createDialogue();
    
    if (FlxG.sound.music != null){
        FlxG.sound.music.stop();

        FlxG.sound.playMusic(Paths.music("goodbye"),1,true);
    }

    dialogue.yap(dialogue, "AfterCorreCorre");
}