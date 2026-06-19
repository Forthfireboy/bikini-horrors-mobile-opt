import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import haxe.Json;
import openfl.utils.Assets;
import Reflect;

function getDialogueLines(sectionData:Dynamic):Array<Dynamic> {
    if (sectionData == null || !(sectionData is Array))
        return [];
    return sectionData;
}

function getDialogueText(data:Dynamic):String {
    if (data == null)
        return "";

    var value:Dynamic = null;
    if (Reflect.hasField(data, "text"))
        value = Reflect.field(data, "text");
    else if (Reflect.hasField(data, "talk"))
        value = Reflect.field(data, "talk");

    return value == null ? "" : Std.string(value);
}

function getDialogueField(data:Dynamic, field:String):Dynamic {
    if (data == null || !Reflect.hasField(data, field))
        return null;
    return Reflect.field(data, field);
}

function newDialogueManager(jsonPath:String, figure:FlxSprite, hands:FlxSprite, config:Dynamic) {
    trace("manager created");
    trace(config);

    if (config == null) config = {};

    var manager:Dynamic = {
        fullJsonData: null,
        dialogueData: [],
        currentLine: 0,
        isTyping: false,
        finished: false,
        isTransitioning: false,
        targetFigure: figure,
        hands: hands,
        display: null,
        textBox: null,
        config: config,

        _textColor : FlxColor.WHITE,
        _yVisibleOffset : 0,
        _timer: 0,
        _delay: 0.03,
        _curLength: 0,
        _finalText: "",

        _boxYVisible: 0,
        _boxYHidden: 0,
        _animType : "none",
        _stopWhenFinish : true,
        // =========================
        // START DIALOGUE
        // =========================
        yap: function(self:Dynamic, section:String) {
            if (self.fullJsonData == null) return;

            if (Reflect.hasField(self.fullJsonData, section)) {
                self.dialogueData = getDialogueLines(Reflect.field(self.fullJsonData, section));
                self.currentLine = 0;
                self.finished = false;
                self.isTransitioning = true;

                self.textBox.y = self._boxYHidden;
                self.display.y = self._boxYHidden + 70;

                self.textBox.visible = false;
                self.display.visible = false;

                var _self = self;

                FlxTween.tween(self.textBox, {y: self._boxYVisible}, 0.6, {
                    ease: FlxEase.expoOut,
                    startDelay: 0,
                    onStart: function(twn:FlxTween) {
                        _self.textBox.visible = true;
                    }
                });

                FlxTween.tween(self.display, {y: self._boxYVisible + 70 + self._yVisibleOffset}, 0.6, {
                    ease: FlxEase.expoOut,
                    startDelay: 0,
                    onStart: function(twn:FlxTween) {
                        _self.display.visible = true;
                    },
                    onComplete: function(twn:FlxTween) {
                        _self.isTransitioning = false;
                        _self.startLine(_self);
                    }
                });
            }
        },

        // =========================
        // LINE START
        // =========================
        startLine: function(self:Dynamic) {

            if (self.dialogueData == null)
                self.dialogueData = [];

            if (self.currentLine >= self.dialogueData.length) {
                self.endDialogue(self);
                return;
            }

            var data = self.dialogueData[self.currentLine];
            var animName = getDialogueField(data, "anim");
            var specialName = getDialogueField(data, "special");

            self._finalText = getDialogueText(data);
            self._curLength = 0;
            self._timer = 0;
            self.display.text = "";
            self.isTyping = true;

            if (self.targetFigure != null && animName != null) {
                self.targetFigure.playAnim(animName);

                if (self._animType != "none"){
                var old_pos = self.targetFigure.y;
                self.targetFigure.y += 10;
                FlxTween.cancelTweensOf(self.targetFigure);
                FlxTween.tween(self.targetFigure, {y: old_pos, alpha: 1}, 0.5,
                    {ease: FlxEase.expoOut});
                }
            }

            if (self.hands != null && specialName == "hands") {
                self.hands.alpha = 1;
                self.display.camera.shake(0.02, 0.12);
            } else if (self.hands != null) {
                self.hands.alpha = 0;
            }
        },

        // =========================
        // END DIALOGUE
        // =========================
        endDialogue: function(self:Dynamic) {

            self.isTransitioning = true;

            var _self = self;

            FlxTween.tween(self.textBox, {y: self._boxYHidden}, 0.5,
                {ease: FlxEase.quadIn});

            FlxTween.tween(self.display, {y: self._boxYHidden + 70}, 0.5, {
                ease: FlxEase.quadIn,
                onComplete: function(twn:FlxTween) {
                    _self.finished = true;
                    _self.isTransitioning = false;
                    _self.textBox.visible = false;
                    _self.display.visible = false;
                }
            });
        },

        // =========================
        // UPDATE
        // =========================
        update: function(self:Dynamic, elapsed:Float) {

            if (self.isTransitioning) return;

            if (self.isTyping) {
                if (self._finalText == null)
                    self._finalText = "";

                self._timer += elapsed;

                if (self._timer > self._delay) {

                    if (self._curLength < self._finalText.length) {

                        var char = self._finalText.charAt(self._curLength);
                        self.display.text += char;
                        self._curLength++;
                        self._timer = 0;

                        if (char == ".")
                            self._timer = -0.25;
                        else if (char == "," || char =="!" || char == "?")
                            self._timer = -0.12;

                    } else {
                        self.isTyping = false;
                        self._timer = 0;
                        if (self._stopWhenFinish)
                        {
                            var curAnim = self.targetFigure != null ? self.targetFigure.animation.curAnim : null;

                            if (curAnim != null)
                            {
                                var animName:String = curAnim.name;

                                if (animName.indexOf("talk") != -1)
                                {
                                    self.targetFigure.playAnim("idle", true);
                                }
                            }
                        }
                    }
                }
            }

            if (FlxG.mouse.justReleased || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.Z) {

                if (self.isTyping) {
                    if (self._finalText == null)
                        self._finalText = "";
                    self.display.text = self._finalText;
                    self._curLength = self._finalText.length;
                    self.isTyping = false;
                    return;
                }

                self.currentLine++;
                self.startLine(self);
            }
        }
    };

    // ==================================================
    // CONFIG VALUES
    // ==================================================
    var textColor =
        Reflect.hasField(config, "textColor")
        ? Reflect.field(config, "textColor")
        : FlxColor.WHITE;

    var yVisibleOffset:Float =
        Reflect.hasField(config, "yVisibleOffset")
        ? Reflect.field(config, "yVisibleOffset")
        : 0;
    
    var stopWhenFinish:Bool =
        Reflect.hasField(config, "stopWhenFinish")
        ? Reflect.field(config, "stopWhenFinish")
        : true;

    var animType:String =
        Reflect.hasField(config, "animType")
        ? Reflect.field(config, "animType")
        : "none";

    var textboxGraphic:String =
        Reflect.hasField(config, "textboxGraphic")
        ? Reflect.field(config, "textboxGraphic")
        : "menus/prison/textbox";

    var boxX:Null<Float> =
        Reflect.hasField(config, "boxX")
        ? Reflect.field(config, "boxX")
        : null;

    var boxYVisible:Null<Float> =
        Reflect.hasField(config, "boxYVisible")
        ? Reflect.field(config, "boxYVisible")
        : null;

    var boxYHidden:Null<Float> =
        Reflect.hasField(config, "boxYHidden")
        ? Reflect.field(config, "boxYHidden")
        : null;

    var textPaddingX:Float =
        Reflect.hasField(config, "textPaddingX")
        ? Reflect.field(config, "textPaddingX")
        : 50;

    var textAlign:String =
        Reflect.hasField(config, "textAlign")
        ? Reflect.field(config, "textAlign")
        : "center";

    // ==================================================
    // TEXTBOX
    // ==================================================

    manager.textBox = new FlxSprite(0, 0)
        .loadGraphic(Paths.image(textboxGraphic));

    manager.textBox.scale.set(0.67, 0.67);
    manager.textBox.updateHitbox();

    if (boxX != null)
        manager.textBox.x = boxX;
    else {
        manager.textBox.screenCenter("x");
        manager.textBox.x += 10;
    }

    manager._textColor = textColor;
    manager._animType = animType;
    manager._stopWhenFinish = stopWhenFinish;
    manager._yVisibleOffset = yVisibleOffset;

    manager.textBox.antialiasing = true;

    manager._boxYVisible =
        boxYVisible != null
        ? boxYVisible
        : FlxG.height - manager.textBox.height - 20;

    manager._boxYHidden =
        boxYHidden != null
        ? boxYHidden
        : FlxG.height + 200;

    manager.textBox.y = manager._boxYHidden;
    manager.textBox.visible = false;

    // ==================================================
    // TEXT DISPLAY (AUTO WIDTH + PADDING)
    // ==================================================

    manager.display = new FlxText(
        manager.textBox.x + textPaddingX,
        manager.textBox.y + 70 - manager._yVisibleOffset,
        manager.textBox.width - (textPaddingX * 2),
        "",
        32
    );


    manager.display.setFormat(
        Paths.font("KrabbyPatty.otf"),
        32,
        manager._textColor,
        textAlign
    );

    manager.display.setBorderStyle(
        FlxTextBorderStyle.SHADOW,
        FlxColor.BLACK,
        3
    );

    manager.display.antialiasing = true;
    manager.display.visible = false;

    // ==================================================
    // LOAD JSON
    // ==================================================

    var path = Paths.json("dialogue/" + jsonPath);
    if (!Assets.exists(path))
        path = "data/dialogue/" + jsonPath + ".json";

    if (Assets.exists(path))
        manager.fullJsonData = Json.parse(Assets.getText(path));

    return manager;
}
