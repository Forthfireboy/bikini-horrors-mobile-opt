function onPlayerHit(event) {
    if (event.noteType == "Money Note") {
        money += 1;
        goodigod.alpha = 1;
        FlxG.sound.play(Paths.sound("bubblepop"), 0.5);
        FlxTween.tween(goodigod, { alpha: 0 }, 1);
    }
}

function onPlayerMiss(event)
{
if(event.noteType == "Money Note"){
        event.cancel(true);
        event.note.strumLine.deleteNote(e.note);
    }
}