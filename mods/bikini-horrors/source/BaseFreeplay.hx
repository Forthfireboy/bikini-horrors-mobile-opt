import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.MusicBeatState;

import funkin.backend.shaders.CustomShader;
import funkin.menus.FreeplayState.FreeplaySonglist;

class BaseFreeplay
{

    //Reference to the state
    public var state:FlxState;

    //Versions data
    static public var v1List:Array = [
        "guater-game",
        "f-is-for-fevil",
        "infinete",
        "sunderwater",
        "catch-and-fish",
        "bubbletwister"
    ];

    static public var v3List:Array = [
        "vash-a-morir",
        "paracetamol",
        "ups-me-caigo",
        "rent-due",
        "rumbeling",
        "powerscaling",
        "barnacles",
        "made-in-china",
        "steamunlocked",
        "flintstone",
        "pool-parti",
        "mega-mortal-madness",
    ];

    static public var v2List:Array = [
        "i-am-back",
        "wordle",
        "fertility",
        "so-retro",
        "no-phone-zone",
        "chromosome",
        "daddatel",
        "try-and-trong",          
        "aloha-aloha",
        "unheard",
        "go-to-eat",
        "pneumonoultramicroscopicsilicovolcanoconiosis",
        "carmaland-retake",
        "pop-a-corn",
        "spotting",
        "kaka",
        "ayuda-por-favor",
        "la-playa",
        "for-you-someday",
        "corre-corre-que-te-pillo"
    ];

    public var songs:Array<Dynamic> = [];
    public var curSelected:Int = 0;
    public var moveFreeze:Bool = false;
    public var selectFreeze:Bool = false;

    public var music:String = "breakfast";

    public var songMixes:Map<String, Array<String>> = [];
    public var songCutscenes:Map<String, String> = [];

    //visual objects
    public var border:FlxSprite;
    public var covers:Array<FlxSprite> = [];
    public var eyes:Array<FlxSprite> = [];

    public var songTitle:FlxText;

    public var transShader:CustomShader;
    public var tweenProgress:FlxTween;

    //general menu callbacks
    public var onSelectionChanged:Int->Void = null;
    public var onAccept:Void->Void = null;
    public var onEscape:Void->Void = null;

    //transition callbacks
    public var onSongTransitionStarted:Void->Void = null;
    public var onSongTransitionFinished:Void->Void = null;

    //returns true if there was a custom load method
    public var onCustomSongLoad:String->Bool = null;

    //vars for song transition anim
    public var selectingSong:Bool = false;

    public var targetZoom:Float = 2.2;
    public var moveAmount:Float = 300;
    public var moveUpAmount:Float = -110;

    public var alertStory:Bool = false;

    //Constructor

    public function new(s:FlxState, v:Int)
    {
        if (FlxG.save.data.clearedSongs == null) {
            FlxG.save.data.clearedSongs = v1List;
            FlxG.save.flush();
        }

        state = s;

        playSong();

        songs = getSongs(v);

        // Explicitly check if save data exists, otherwise fall back to 0
        if (FlxG.save.data.lastSelectedSong != null)
        {
            curSelected = FlxG.save.data.lastSelectedSong;

            // Prevent out-of-bounds index errors if the song list size changed
            if (curSelected >= songs.length || curSelected < 0)
                curSelected = 0;
        }
        else 
        {
            curSelected = 0; //in case no song is stored
        }

        
    }

    public function playSong(){
        if (FlxG.sound.music != null){
            FlxG.sound.music.stop();

            FlxG.sound.playMusic(Paths.music(music),1,true);
        }
    }

    //Get the songs

    public function getSongs(v)
    {
        var finalArray:Array = [];
        var list = FreeplaySonglist.get().songs;
        var targetArray:Array;
        switch (v){
            case 1:
                targetArray = v1List;
            case 2:
                targetArray = v2List;
            case 3:
                targetArray = v3List;
        }
        
        for (song in list){
            if (targetArray.contains(song.name.toLowerCase())){
                finalArray.push(song);
            }
        }

        return finalArray;
    }

    // Helper function to determine if a song is unlocked
    public function isSongUnlocked(index:Int):Bool {
        if (index == 0) return true;
        
        var previousSongName:String = songs[index - 1].name.toLowerCase();
        var clearedList:Array<String> = FlxG.save.data.clearedSongs;
        
        return clearedList.contains(previousSongName);
    }

    // Helper function to determine if a song has been beaten
    public function isSongBeaten(index:Int):Bool {
        var currentSongName:String = songs[index].name.toLowerCase();
        var clearedList:Array<String> = FlxG.save.data.clearedSongs;
        
        return clearedList.contains(currentSongName);
    }

    //=========================================================
    // EYES
    //=========================================================

    public function createEyes()
    {
        eyes = [];

        for (i => song in songs)
        {
            var name = song.displayName.toLowerCase().split(" ").join("-");

            var ojo = new FlxSprite(805,100);

            ojo.loadGraphic(Paths.image("ojitos/" + name));
            ojo.scale.set(0.28,0.28);
            ojo.updateHitbox();

            ojo.alpha = 0;
            ojo.ID = i;

            eyes.push(ojo);
            state.add(ojo);
        }
    }

    public function updateEyes()
    {
        for (o in eyes)
        {
            FlxTween.cancelTweensOf(o);

            if (o.ID == curSelected)
            {
                o.x = 807;
                o.alpha = 0;
            }
            else
            {
                o.alpha = 0;
            }
        }
    }

    //=========================================================
    // UI
    //=========================================================

    public function createUI()
    {
        border = new FlxSprite(0, 0);

        border.makeGraphic(
            1,
            1,
            0xFF592004
        );

        border.setGraphicSize(
            Std.int(1667*0.25 + 10),
            Std.int(1667*0.25 + 10)
        );

        border.updateHitbox();
        border.screenCenter();

        border.x = 105;
        border.y = 155 - 20;

        state.add(border);
        
        for (i => song in songs)
        {
            var cover = new FlxSprite();

            // Check progression state to determine graphic path asset location
            if (!isSongUnlocked(i)) 
            {
                // State 1: Hard Locked
                cover.loadGraphic(Paths.image("menus/covers/locked"));
            } 
            else if (!isSongBeaten(i)) 
            {
                // State 2: Unlocked but uncompleted
                cover.loadGraphic(Paths.image("menus/covers/unknown"));
            } 
            else 
            {
                // State 3: Beaten and cleared
                var name = song.displayName.toLowerCase().split(" ").join("-");
                cover.loadGraphic(Paths.image("menus/covers/" + name));
            }

            cover.scale.set(0.25, 0.25);
            cover.updateHitbox();
            cover.screenCenter();

            cover.x = 110;
            cover.y = 140;

            cover.alpha = 0;
            cover.ID = i;

            covers.push(cover);
            state.add(cover);
        }

        songTitle = new FlxText(
            0,
            50,
            FlxG.width,
            "SONG"
        );

        songTitle.setFormat(
            Paths.font("KrabbyPatty.otf"),
            35,
            0xFF592004,
            "center"
        );

        if (covers.length > 0)
        {
            songTitle.x =
                covers[0].x +
                (covers[0].width / 2) -
                (songTitle.width / 2);

            songTitle.y =
                covers[0].y + 300;
        }

        state.add(songTitle);
        
        changeSelection(0);
        
        MusicBeatState.instance.addMobilePad("LEFT_RIGHT", "A_B");
    }

    //=========================================================
    // UPDATE
    //=========================================================

    public function update(elapsed:Float)
    {
        
        if (! moveFreeze){
            if (MusicBeatState.instance.controls.LEFT_R)
                changeSelection(-1);

            if (MusicBeatState.instance.controls.RIGHT_R)
                changeSelection(1);
        }
        if (! selectFreeze){
            if (MusicBeatState.instance.controls.ACCEPT)
            {
                if (!isSongUnlocked(curSelected)) {
                    FlxG.sound.play(Paths.sound("menu/cancelMenu"), 1);
                    FlxG.camera.shake(0.005, 0.1); 
                    return;
                }

                if (onAccept != null)
                    onAccept();
                else
                    enterSong();
            }
        }

        if (MusicBeatState.instance.controls.BACK)
        {
            FlxG.save.data.lastSelectedSong = curSelected;
            FlxG.save.flush();

            if (onEscape != null)
                onEscape();
            else
                FlxG.switchState(new ModState("BHTitleState"));
        }
    }

    //=========================================================
    // SELECTION
    //=========================================================

    public function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = songs.length - 1;

        if (curSelected >= songs.length)
            curSelected = 0;

        // Apply string values to titles depending on progression flags
        if (!isSongUnlocked(curSelected)) 
        {
            songTitle.text = "[ LOCKED ]";
        } 
        else if (!isSongBeaten(curSelected)) 
        {
            songTitle.text = "< ??? >";
        } 
        else 
        {
            songTitle.text = "< " + songs[curSelected].displayName.toUpperCase() + " >";
        }

        var cover = covers[curSelected];

        songTitle.x =
            cover.x +
            (cover.width / 2) -
            (songTitle.width / 2);

        songTitle.y =
            cover.y + 430;

        for (cover in covers)
        {
            cover.alpha =
                cover.ID == curSelected ? 1 : 0;
        }

        updateEyes();

        if (onSelectionChanged != null)
            onSelectionChanged(change);
    }

    // ENTER SONG FUNCTION

    public function enterSong()
    {
        selectingSong = true;
        moveFreeze = true;
        selectFreeze = true;

        var songData = songs[curSelected];
        
        if (songMixes.exists(songData.name.toLowerCase())) {
            FlxG.save.data.mixList = songMixes.get(songData.name.toLowerCase());
            FlxG.save.data.songData = songData;
            
            persistentUpdate = false;
            state.openSubState(new ModSubState("ChooseSongMix"));
            return;
        }
        
        FlxG.save.data.lastSelectedSong = curSelected;
        FlxG.save.flush();

        FlxG.sound.play(Paths.sound("menu/freeplay_select"), 1);

        if (onSongTransitionStarted != null)
            onSongTransitionStarted();

        var startX = FlxG.camera.scroll.x;
        var startY = FlxG.camera.scroll.y;

        FlxTween.tween(FlxG.camera, {zoom: targetZoom}, 4, {ease:FlxEase.quadInOut});
        FlxTween.num(startX, startX + moveAmount, 4, {ease:FlxEase.quadInOut}, function(v) { FlxG.camera.scroll.x = v; });
        FlxTween.num(startY, startY + moveUpAmount, 4, {ease:FlxEase.quadInOut}, function(v) { FlxG.camera.scroll.y = v; });

        for (o in eyes) {
            FlxTween.cancelTweensOf(o);
            o.alpha = 0;
        }

        var selectedEye = eyes[curSelected];
        selectedEye.alpha = 0;

        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();

        FlxTween.tween(selectedEye, {alpha:0.15}, 4, {
            ease:FlxEase.quadIn,
            onComplete:function(_) {
                var fadeBlock = new FlxSprite();
                fadeBlock.makeGraphic(1280, 720, FlxColor.BLACK);
                fadeBlock.scrollFactor.set(0,0);
                fadeBlock.alpha = 1;
                state.add(fadeBlock);

                new FlxTimer().start(2.5, function(_) {
                    if (onSongTransitionFinished != null)
                        onSongTransitionFinished();

                    if (songCutscenes.exists(songData.name)) {
                        FlxG.save.data.cutsceneToPlay = songCutscenes[songData.name];
                    } else {
                        FlxG.save.data.cutsceneToPlay = null;
                    }

                    if (onCustomSongLoad != null && onCustomSongLoad(songData.name)) {
                        return;
                    }

                    PlayState.loadSong(songData.name, songData.difficulties[0]);
                    FlxG.switchState(new ModState("StartCredits"));
                    saveData();
                });
            }
        });
    }


    public function saveData(){
        trace("I am being called");

        if (FlxG.save.data.clearedSongs == null)
        {
            FlxG.save.data.clearedSongs = [
                "guater-game",
                "f-is-for-fevil",
                "sunderwater",
                "catch-and-fish",
                "bubbletwister"
            ];
        }

        var currentSongName:String = PlayState.SONG.meta.name.toLowerCase();

        if (!FlxG.save.data.clearedSongs.contains(currentSongName))
        {
            FlxG.save.data.clearedSongs.push(currentSongName);
            FlxG.save.flush();
        }
    }

    public function selectSong(name:String):Bool
    {
        var target = name.toLowerCase();

        for (i => song in songs)
        {
            if (song.name.toLowerCase() == target)
            {
                curSelected = i;
                changeSelection(0);
                return true;
            }
        }

        return false;
    }

}