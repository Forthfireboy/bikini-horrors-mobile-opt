var skinName:String = "default";
var ogStrumX:Array<Array<Float>> = [];


function onNoteHit(e)
{
    if (skinName == "sonic")
        e.showSplash = false;

}

function postCreate()
{
    ogStrumX = [];

    for (line in strumLines.members)
    {
        if (line == null) continue;

        var arr:Array<Float> = [];

        for (strum in line.members)
        {
            if (strum == null) continue;
            arr.push(strum.x);
        }

        ogStrumX.push(arr);
    }
}

function applyStrumOffset(isSonic:Bool)
{
    for (i in 0...strumLines.members.length)
    {
        var line = strumLines.members[i];
        if (line == null || ogStrumX[i] == null) continue;

        for (j in 0...line.members.length)
        {
            var strum = line.members[j];
            if (strum == null || ogStrumX[i][j] == null) continue;

            var targetX = ogStrumX[i][j];

            if (isSonic)
                targetX -= 40;

            FlxTween.tween(strum, {
                x: targetX
            }, 0.3, { ease: FlxEase.quadOut });
        }
    }
}

function stepHit(curStep:Int)
{
    switch (curStep)
    {
        case 544:
            changeSkin("sonic");

        case 1054:
            changeSkin("default");
    }
}

function changeSkin(skin:String)
{
    skinName = skin;

    sonicMode = (skin == "sonic");

    var path:String = skin == ""
        ? "game/notes/default"
        : "game/notes/" + skin;

    applyStrumOffset(skin == "sonic"); 

    for (i in 0...strumLines.members.length)
    {
        var group = strumLines.members[i];
        if (group == null) continue;

        for (strum in group.members)
            updateStrum(strum, path, i);

        for (note in group.notes)
            updateNote(note, path);
    }
}

function updateStrum(strum:Strum, atlas:String, line:Int)
{
    strum.frames = Paths.getSparrowAtlas(atlas);

    if (strum.animation != null)
        strum.animation.destroyAnimations();

    var dirNames = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
    var dir:String = dirNames[strum.ID % 4];

    if (skinName == "kahoot_noteSkin")
    {
        var colors = ['purple', 'blue', 'green', 'red'];
        var color = colors[strum.ID % 4];

        strum.animation.addByPrefix('static', color + '_idle', 24, false);
        strum.animation.addByPrefix('pressed', color + '_push', 24, false);
        strum.animation.addByPrefix('confirm', color + '_confirm', 24, false);
    }

    else if (skinName == "sonic")
    {
        var lower = dir.toLowerCase();

        strum.animation.addByPrefix('static', 'arrow' + dir, 24, false);
        strum.animation.addByPrefix('pressed', lower + ' press', 24, false);

        // Don't give confirm anims to strumline 0
        if (line != 0)
            strum.animation.addByPrefix('confirm', lower + ' confirm', 24, false);
    }
    else
    {
        var lower = dir.toLowerCase();

        strum.animation.addByPrefix('static', 'arrow' + dir, 24, false);
        strum.animation.addByPrefix('pressed', lower + ' press', 24, false);
        strum.animation.addByPrefix('confirm', lower + ' confirm', 24, false);
    }

    strum.animation.play("static");
    strum.updateHitbox();
}

function updateNote(note:Note, atlas:String)
{
    var currentAnim:String = "scroll";

    if (note.animation != null && note.animation.curAnim != null)
        currentAnim = note.animation.curAnim.name;

    note.frames = Paths.getSparrowAtlas(atlas);

    if (note.animation != null)
        note.animation.destroyAnimations();

    var colors = ['purple', 'blue', 'green', 'red'];
    var color:String = colors[note.noteData % 4];

    if (skinName == "kahoot_noteSkin")
    {
        note.animation.addByPrefix('scroll', color + '_note', 24, false);
        note.animation.addByPrefix('hold', color + '_tail', 24, false);
        note.animation.addByPrefix('holdend', color + '_tail_end', 24, false);
    }
    else
    {
        note.animation.addByPrefix('scroll', color + '0', 24, false);
        note.animation.addByPrefix('hold', color + ' hold piece', 24, false);

        if (color == "purple")
            note.animation.addByPrefix('holdend', 'pruple end hold', 24, false);
        else
            note.animation.addByPrefix('holdend', color + ' hold end', 24, false);
    }

    if (note.animation.getByName(currentAnim) != null)
        note.animation.play(currentAnim, true);
    else
        note.animation.play("scroll", true);

    note.updateHitbox();


}

