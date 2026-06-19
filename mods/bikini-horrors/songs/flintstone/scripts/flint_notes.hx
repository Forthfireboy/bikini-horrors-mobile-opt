public var finalNotesScale:Float = 2;

var noteSkin:String = "notes_flintstone";
var splashSkin:String = null;

function create()
{
	noteSkin = "notes_flintstone";
	splashSkin = null;

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
    Note.swagWidth = 110;
	e.sprite = "game/notes/" + noteSkin;
}

function onPostStrumCreation(e)
{
	e.strum.antialiasing = false;

	e.strum.scale.set(finalNotesScale, finalNotesScale);
	e.strum.updateHitbox();
}

function onNoteCreation(e)
{
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