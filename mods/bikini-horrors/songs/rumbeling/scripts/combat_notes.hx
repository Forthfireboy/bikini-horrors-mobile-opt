public var finalNotesScale:Float = 0.7;

var noteSkin:String = "combat";
var splashSkin:String = null;

function create()
{
    noteSkin = "combat";
    splashSkin = "game/noteSplashes/default";

    if (stage != null && stage.stageXML != null)
	{
		if (stage.stageXML.exists("noteSkin"))
			noteSkin = stage.stageXML.get("noteSkin");

		if (stage.stageXML.exists("splashSkin"))
			splashSkin = stage.stageXML.get("splashSkin");
	}
}

function onStrumCreation(e)
{
    
    e.sprite = "game/notes/combat";
}

function onPostStrumCreation(e)
{
    e.strum.antialiasing = false;

	e.strum.scale.set(finalNotesScale, finalNotesScale);
	e.strum.updateHitbox();

    var lekID:Int = e.strum.ID % 4;
    

    var posicionInicialLinea:Float = e.strum.x - (lekID * 112);
    e.strum.x = posicionInicialLinea + (lekID * 130);
}

function onNoteCreation(e)
{
    if (e.noteType == "ShootNote") return;

    if (e.noteType != null
	&& Assets.exists(Paths.image("game/notes/" + e.noteType)))
	{
		e.noteSprite = "game/notes/" + e.noteType;
	}
	else
	{
		e.noteSprite = "game/notes/" + noteSkin;
	}
}

function onPostNoteCreation(e)
{
    e.note.antialiasing = false;
	e.note.splash = splashSkin;

	e.note.scale.set(finalNotesScale, finalNotesScale);
	e.note.updateHitbox();
}

function onNoteHit(e)
{
    if (splashSkin == null)
		e.showSplash = false;
}