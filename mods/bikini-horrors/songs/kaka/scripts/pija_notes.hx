var skinName:String = "default";
var targetStrumID:Int = 1;

function stepHit(curStep:Int) {
    if (curStep == 3808) {
        skinName = "noteskin_caca";
        changeSkin(skinName, targetStrumID);
    }
}

function getSkinPath(skin:String):String {
    return (skin == "" || skin == "default") ? "game/notes/default" : "game/notes/" + skin;
}

function changeSkin(skin:String, strumID:Int) {
    skinName = skin;
    var path:String = getSkinPath(skin);
    var group = strumLines.members[strumID];
    if (group == null) return;

    for (strum in group.members) updateStrum(strum, path);
    for (note in group.notes) updateNote(note, path);
}

function onPostNoteCreation(e) {
    if (skinName == "" || skinName == "default") return;
    if (e == null || e.note == null) return;
    if (e.strumLineID != targetStrumID) return;

    updateNote(e.note, getSkinPath(skinName));
}

function updateStrum(theStrum:Strum, newSkin:String) {
    if (theStrum == null) return;

    theStrum.frames = Paths.getSparrowAtlas(newSkin);
    var noteDirs = ['purple', 'blue', 'green', 'red'];
    var color = noteDirs[theStrum.ID % 4];
    var suffixes = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
    var dir = suffixes[theStrum.ID % 4];

    if (skinName == "kahoot_noteSkin") {
        theStrum.animation.addByPrefix('static', color + '_idle', 24, false);
        theStrum.animation.addByPrefix('pressed', color + '_push', 24, false);
        theStrum.animation.addByPrefix('confirm', color + '_confirm', 24, false);
    } else {
        var dirLower = dir.toLowerCase();
        theStrum.animation.addByPrefix('static', 'arrow' + dir, 24); 
        theStrum.animation.addByPrefix('pressed', dirLower + ' press', 24);
        theStrum.animation.addByPrefix('confirm', dirLower + ' confirm', 24);
    }

    theStrum.animation.play('static');
    theStrum.updateHitbox();
}

function updateNote(theNote:Note, newSkin:String) {
    if (theNote == null) return;

    var isHold:Bool = theNote.isSustainNote;
    var animToPlay:String;

    if (!isHold) {
        animToPlay = "scroll";
    } else if (theNote.nextNote != null) {
        animToPlay = "hold";
    } else {
        animToPlay = "holdend";
    }
    
    theNote.frames = Paths.getSparrowAtlas(newSkin);
    
    if (theNote.animation != null) theNote.animation.destroyAnimations();

    var noteDirs = ['purple', 'blue', 'green', 'red'];
    var color = noteDirs[theNote.noteData % 4];

    if (skinName == "kahoot_noteSkin") {
        theNote.animation.addByPrefix('scroll', color + '_note', 24, false);
        theNote.animation.addByPrefix('hold', color + '_tail', 24, false);
        theNote.animation.addByPrefix('holdend', color + '_tail_end', 24, false); 
    } else {
        theNote.animation.addByPrefix('scroll', color + '0', 24, true); 
        theNote.animation.addByPrefix('hold', color + ' hold piece', 24, true); 
        
        if (color == 'purple')
            theNote.animation.addByPrefix('holdend', 'purple end hold', 24, true);
        else
            theNote.animation.addByPrefix('holdend', color + ' hold end', 24, true);
    }
    theNote.animation.play(animToPlay, true); 

    theNote.updateHitbox();
}

