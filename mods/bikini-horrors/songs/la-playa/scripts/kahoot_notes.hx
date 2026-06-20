var skinName:String = "default";

function onNoteHit(e)
{
    if (skinName == "kahoot_noteSkin")
        e.showSplash = false;

}


function stepHit(curStep:Int) {
    if (curStep == 1264) {
        skinName = "kahoot_noteSkin";
        changeSkin(skinName);
    }
    if (curStep == 1520) {
        skinName = "default";
        changeSkin(skinName);
    }
}

function getSkinPath(skin:String):String
{
    return (skin == "" || skin == "default")
        ? "game/notes/default"
        : "game/notes/" + skin;
}

function changeSkin(skin:String)
{
    skinName = skin;
    var path:String = getSkinPath(skin);

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

function onPostNoteCreation(e)
{
    if (skinName == "" || skinName == "default") return;
    if (e == null || e.note == null) return;

    updateNote(e.note, getSkinPath(skinName));
}

function updateStrum(strum:Strum, atlas:String, line:Int)
{
    if (strum == null) return;

    strum.frames = Paths.getSparrowAtlas(atlas);

    if (strum.animation != null)
        strum.animation.destroyAnimations();

    var dirNames = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
    var dir:String = dirNames[strum.ID % 4];
    
    var lower:String = dir.toLowerCase(); 

    if (skinName == "kahoot_noteSkin")
    {
        var colors = ['purple', 'blue', 'green', 'red'];
        var color = colors[strum.ID % 4];

        strum.animation.addByPrefix('static', color + '_idle', 24, false);
        strum.animation.addByPrefix('pressed', color + '_push', 24, false);
        strum.animation.addByPrefix('confirm', color + '_confirm', 24, false);

        if (line != 0)
            strum.animation.addByPrefix('confirm', lower + ' confirm', 24, false); // Ahora sí funciona
    }
    else
    {
        strum.animation.addByPrefix('static', 'arrow' + dir, 24, false);
        strum.animation.addByPrefix('pressed', lower + ' press', 24, false);
        strum.animation.addByPrefix('confirm', lower + ' confirm', 24, false);
    }

    strum.animation.play("static");
    strum.updateHitbox();
}

function updateNote(note:Note, atlas:String)
{
    if (note == null) return;

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
            note.animation.addByPrefix('holdend', 'purple end hold', 24, false);
        else
            note.animation.addByPrefix('holdend', color + ' hold end', 24, false);
    }

    if (note.animation.getByName(currentAnim) != null)
        note.animation.play(currentAnim, true);
    else
        note.animation.play("scroll", true);

    note.updateHitbox();


}
