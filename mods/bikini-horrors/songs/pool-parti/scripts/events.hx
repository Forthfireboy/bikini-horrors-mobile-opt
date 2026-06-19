
import funkin.game.StageCharPos;
import funkin.backend.utils.WindowUtils;

function postCreate() {
    WindowUtils.winTitle = window.title = "POOL PARTI";
}

function showStrumLineNotes(lineIndex:Int, duration:Float = 0.5) {
    if (strumLines == null || strumLines.members == null || lineIndex < 0 || lineIndex >= strumLines.members.length)
        return;

    var strumLine = strumLines.members[lineIndex];
    if (strumLine == null)
        return;

    strumLine.extra.set("hudAlpha", 1);

    for (strum in strumLine.members)
        if (strum != null)
            FlxTween.tween(strum, {alpha: 1}, duration, {ease: FlxEase.quadOut});

    if (strumLine.notes != null)
        for (note in strumLine.notes)
            if (note != null)
                FlxTween.tween(note, {alpha: note.__baseAlpha}, duration, {ease: FlxEase.quadOut});
}

function showAllHudNotes(duration:Float = 0.5) {
    setHudArrowsAlpha(1, duration, FlxEase.quadOut);
}

function stepHit(curStep:Int) {

    if (curStep == 1312)
    {
        WindowUtils.winTitle = window.title = "MINIONS";
    }

    if (curStep == 2896)
    {
        WindowUtils.winTitle = window.title = "SMOKING AND VAPING";
    }

    if (curStep == 3516)
    {
        showStrumLineNotes(1);
    }

    if (curStep == 4000)
    {
        WindowUtils.winTitle = window.title = "WE ARE BIKINI HORRORS";
    }

    if (curStep == 1375) {
        showStrumLineNotes(1);
    }

    if (curStep == 4032) {
        showAllHudNotes();
    }

    if (curStep == 4733) {
        showAllHudNotes();
    }
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}
