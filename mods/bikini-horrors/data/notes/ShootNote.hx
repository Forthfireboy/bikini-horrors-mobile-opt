function onNoteCreation(event) {
    if (event.noteType == "ShootNote" && FlxG.save.data.mech == true) {
        event.note.alpha = 0;
    }
}

function onPlayerHit(event) {
    if (event.noteType == "ShootNote" && FlxG.save.data.mech != true) {
        FlxG.sound.play(Paths.sound("gunShot"), 1);
        event.animCancelled = true;
        boyfriend.playAnim("dodge");
        dad.playAnim("shoot");
    }
}

function onPlayerMiss(event)
{
    if(event.noteType == "ShootNote" && FlxG.save.data.mech != true)
    {
        FlxG.sound.play(Paths.sound("gunShot"), 1);
        dad.playAnim("shoot");

        event.healthGain = -0.4;
    }
}