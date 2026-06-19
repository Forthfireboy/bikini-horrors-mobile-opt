var spawnedNotes:Array<FlxSprite> = [];
public var notesEffectEnabled:Bool = false;

public var bgCam = new FlxCamera();
var notesCam = new FlxCamera();
var fishEyeShader:CustomShader = null;

function postCreate()
{
    //We copy the shaders from the main cam
    if (camGame.filters != null){
        bgCam.setFilters(camGame.filters.copy());
        notesCam.setFilters(camGame.filters.copy());
    }

    strumLines.members[0].onNoteUpdate.add(onNoteUpdate);

    FlxG.cameras.remove(camGame, false);
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(bgCam, false);
    FlxG.cameras.add(notesCam, false);
    FlxG.cameras.add(camGame, true);
    FlxG.cameras.add(camHUD, false);
    fishEyeShader = new CustomShader("fishEye");
    fishEyeShader.intensity = 0.08;
    fishEyeShader.zoom = 1;
    camGame.bgColor = FlxColor.TRANSPARENT;
    notesCam.addShader(fishEyeShader);
    bgCam.bgColor = FlxColor.TRANSPARENT;
    notesCam.bgColor = FlxColor.TRANSPARENT;
}

function onNoteUpdate(e)
{
    if (!notesEffectEnabled)
        return;

    if (e.note.extra.exists("spawnedDecoration"))
        return;

    e.note.extra.set("spawnedDecoration", true);

    var spr = new FlxSprite();

    var randomNum = FlxG.random.int(1, 6);
    spr.loadGraphic(Paths.image("stages/basement/notes/nota" + randomNum));

    spr.x = 3280;

    var laneY = 0;

    switch (e.note.noteData)
    {
        case 0: laneY = 800; // left
        case 1: laneY = 600; // down
        case 2: laneY = 400; // up
        case 3: laneY = 200; // right
    }

    spr.y = laneY;
    spr.scale.x = 1.3;
    spr.scale.y = 1.3;
    spr.cameras = [notesCam];
    add(spr);
    applyGlitch(spr);
    spawnedNotes.push(spr);
}

function update(elapsed:Float)
{
    bgCam.scroll = camGame.scroll;
    bgCam.zoom = camGame.zoom;

    notesCam.scroll = camGame.scroll;
    notesCam.zoom = camGame.zoom;

    for (i in 0...spawnedNotes.length)
    {
        var spr = spawnedNotes[i];
        spr.x -= 2000 * elapsed;
    }

    var i = spawnedNotes.length - 1;
    while (i >= 0)
    {
        var spr = spawnedNotes[i];

        if (spr.x <= 200)
        {
            remove(spr);
            spr.destroy();
            spawnedNotes.splice(i, 1);
        }

        i--;
    }
}

function applyGlitch(obj:FlxSprite)
{
    if (!Options.gameplayShaders) return;

    obj.shader = glitchShader;
    glitchActive = true;
}