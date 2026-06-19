// Script by Aika
var preloadedCharacters:Map<String, Character> = [];

function postCreate() {
    if (FlxG.save.data.cg == true) {
        changeBf();
        changeGf();
    }
}

function changeGf() {
    var newCharID:String = "girlfriday_goon";

        if (!preloadedCharacters.exists(newCharID)) {
            var oldCharacter:Character = gf;
            var newCharacter = new Character(oldCharacter.x, oldCharacter.y, newCharID, oldCharacter.isPlayer);
            newCharacter.active = newCharacter.visible = false;
            newCharacter.drawComplex(FlxG.camera);
            preloadedCharacters.set(newCharID, newCharacter);

            if (newCharacter.isGF) {
                newCharacter.cameraOffset.x += stage.characterPoses["gf"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["gf"].camyoffset;
            }
        }

        var oldCharacter = gf;
        var newCharacter = preloadedCharacters.get(newCharID);
        if (oldCharacter.curCharacter != newCharacter.curCharacter) {
            insert(members.indexOf(oldCharacter), newCharacter);
            newCharacter.active = newCharacter.visible = true;
            remove(oldCharacter);

            newCharacter.isPlayer = oldCharacter.isPlayer;
            newCharacter.fixChar(true);
            newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
            newCharacter.playAnim(oldCharacter.animation.name);
            newCharacter.animation?.curAnim?.curFrame = oldCharacter.animation?.curAnim?.curFrame;
            gf = newCharacter;
        }
}

function changeBf() {
    var newCharID:String = "boyfriday_goon";

        if (!preloadedCharacters.exists(newCharID)) {
            var oldCharacter:Character = strumLines.members[2].characters[0];
            var newCharacter = new Character(oldCharacter.x, oldCharacter.y, newCharID, oldCharacter.isPlayer);
            newCharacter.active = newCharacter.visible = false;
            newCharacter.drawComplex(FlxG.camera);
            preloadedCharacters.set(newCharID, newCharacter);

            if (newCharacter.playerOffsets) {
                newCharacter.cameraOffset.x += stage.characterPoses["boyfriend"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["boyfriend"].camyoffset;
            }
        }

        var oldCharacter = strumLines.members[1].characters[0];
        var newCharacter = preloadedCharacters.get(newCharID);
        if (oldCharacter.curCharacter != newCharacter.curCharacter) {
            insert(members.indexOf(oldCharacter), newCharacter);
            newCharacter.active = newCharacter.visible = true;
            remove(oldCharacter);

            newCharacter.isPlayer = oldCharacter.isPlayer;
            newCharacter.fixChar(true);
            newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
            newCharacter.playAnim(oldCharacter.animation.name);
            newCharacter.animation?.curAnim?.curFrame = oldCharacter.animation?.curAnim?.curFrame;
            strumLines.members[1].characters[0] = newCharacter;
        }
}
