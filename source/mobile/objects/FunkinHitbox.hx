package mobile.objects;

import mobile.Hitbox;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import openfl.display.BitmapData;
import openfl.display.Shape;

class FunkinHitbox extends Hitbox {
	public static inline var DEFAULT_EXTRA_COLOR:Int = 0xFFFFFF00;

	public var currentMode:String;
	public var showHints:Bool;
	private var syncedKeys:Map<Int, Bool> = [];
	private var extraHitboxButtons:Array<MobileButton> = [];

	public function new(?mode:String, ?showHints:Bool):Void
	{
		super(mode, false); //false means library's hitbox creation is disabled.
		currentMode = mode; //use this there.
		this.showHints = showHints;

		/*
			Legacy JSON-driven hitbox backup:

			if (mode != null && mode != "NONE" && MobileConfig.hitboxModes.exists(mode)) {
				for (buttonData in MobileConfig.hitboxModes.get(mode).hints) {
					addHint(buttonData.button, buttonData.buttonIDs, buttonData.buttonUniqueID,
						buttonData.position[0], buttonData.position[1],
						buttonData.scale[0], buttonData.scale[1],
						Util.colorFromString(buttonData.color), buttonData.returnKey);
				}
			}
		*/

		// The mobile port uses a strict four-lane full-screen hitbox. Special
		// songs call addExtraKey() when they need a separate SPACE region.
		createDefaultNoteHitboxes();

		scrollFactor.set();
		updateTrackedButtons();

		instance = this;
	}

	private function createDefaultNoteHitboxes():Void
	{
		var laneWidth:Float = FlxG.width / 4;
		var laneHeight:Int = Std.int(FlxG.height);
		var names:Array<String> = ["buttonNote1", "buttonNote2", "buttonNote3", "buttonNote4"];
		var ids:Array<Array<String>> = [["NOTE_LEFT"], ["NOTE_DOWN"], ["NOTE_UP"], ["NOTE_RIGHT"]];
		var colors:Array<Int> = [0xFFFF00FF, 0xFF00FFFF, 0xFF00FF00, 0xFFFF0000];

		for (i in 0...names.length) {
			var x:Float = i * laneWidth;
			var width:Int = (i == names.length - 1) ? Std.int(FlxG.width - x) : Std.int(Math.ceil(laneWidth));
			addHint(names[i], ids[i], i, x, 0, width, laneHeight, colors[i]);
		}
	}

	public function addExtraKey(key:String = "SPACE", ?buttonID:String, color:Int = DEFAULT_EXTRA_COLOR):MobileButton
	{
		if (key == null || key == "")
			key = "SPACE";
		key = key.toUpperCase();

		if (buttonID == null || buttonID == "")
			buttonID = key;

		var buttonName:String = 'buttonExtra_$key';
		if (hintMap.exists(buttonName))
			return hintMap.get(buttonName);

		var buttonIDs:Array<String> = ["EXTRA_1"];
		for (id in [buttonID, key])
			if (id != null && id != "" && !buttonIDs.contains(id))
				buttonIDs.push(id);

		var buttonHeight:Int = getExtraRegionHeight();
		var buttonY:Float = Options.hitboxPos ? 0 : FlxG.height - buttonHeight;
		addHint(buttonName, buttonIDs, -1, 0, buttonY, FlxG.width, buttonHeight, color, key);

		var button = hintMap.get(buttonName);
		if (button != null) {
			button.cameras = cameras;
			if (!extraHitboxButtons.contains(button))
				extraHitboxButtons.push(button);
			layoutExtraHitboxRegion();
			keepExtraKeySeparate(button);
		}
		updateTrackedButtons();
		return button;
	}

	private function getExtraRegionHeight():Int
		return Std.int(FlxG.height / 4);

	private function isExtraHitboxButton(button:MobileButton):Bool
		return button != null && extraHitboxButtons != null && extraHitboxButtons.contains(button);

	private function isDefaultNoteButton(button:MobileButton):Bool
	{
		if (button == null || isExtraHitboxButton(button))
			return false;
		if (button.uniqueID >= 0 && button.uniqueID <= 3)
			return true;
		if (button.IDs != null)
			for (id in button.IDs)
				if (id != null && id.indexOf("NOTE_") == 0)
					return true;
		return false;
	}

	private function resizeHitboxButton(button:MobileButton, x:Float, y:Float, width:Int, height:Int):Void
	{
		if (button == null)
			return;

		button.setPosition(x, y);
		button.setGraphicSize(width, height);
		button.updateHitbox();

		if (button.hintUp != null) {
			button.hintUp.x = x;
			button.hintUp.y = y;
			button.hintUp.setGraphicSize(width, Std.int(Math.max(1, Math.floor(height * 0.02))));
			button.hintUp.updateHitbox();
		}

		if (button.hintDown != null) {
			button.hintDown.x = x;
			button.hintDown.y = y + button.height - button.hintDown.height;
			button.hintDown.setGraphicSize(width, Std.int(Math.max(1, Math.floor(height * 0.02))));
			button.hintDown.updateHitbox();
		}
	}

	private function layoutExtraHitboxRegion():Void
	{
		if (extraHitboxButtons == null || extraHitboxButtons.length <= 0)
			return;

		var regionHeight:Int = getExtraRegionHeight();
		var gameplayY:Float = Options.hitboxPos ? regionHeight : 0;
		var extraY:Float = Options.hitboxPos ? 0 : FlxG.height - regionHeight;
		var gameplayHeight:Int = Std.int(Math.max(1, FlxG.height - regionHeight));
		var extraWidth:Int = Std.int(Math.ceil(FlxG.width / extraHitboxButtons.length));

		var laneWidth:Float = FlxG.width / 4;
		var laneIndex:Int = 0;
		for (hint in hints)
			if (isDefaultNoteButton(hint)) {
				var x:Float = laneIndex * laneWidth;
				var width:Int = (laneIndex == 3) ? Std.int(FlxG.width - x) : Std.int(Math.ceil(laneWidth));
				resizeHitboxButton(hint, x, gameplayY, width, gameplayHeight);
				laneIndex++;
			}

		for (i in 0...extraHitboxButtons.length) {
			var button = extraHitboxButtons[i];
			var x:Float = i * extraWidth;
			var width:Int = (i == extraHitboxButtons.length - 1) ? Std.int(FlxG.width - x) : extraWidth;
			resizeHitboxButton(button, x, extraY, width, regionHeight);
		}
	}

	private function keepExtraKeySeparate(extraButton:MobileButton):Void
	{
		if (extraButton == null)
			return;

		for (hint in hints) {
			if (hint == null || hint == extraButton)
				continue;
			if (hint.deadZones.indexOf(extraButton) == -1)
				hint.deadZones.push(extraButton);
		}
	}

	private function getKeyboardKey(?returned:String, ?ids:Array<String>):FlxKey
	{
		if (returned != null && returned != "")
			return FlxKey.fromString(returned);

		if (ids != null)
			for (id in ids) {
				var key = FlxKey.fromString(id);
				if (key != FlxKey.NONE && key != FlxKey.ANY)
					return key;
			}

		return FlxKey.NONE;
	}

	private function syncKeyboardKey(key:FlxKey, down:Bool):Void
	{
		if (key == FlxKey.NONE || key == FlxKey.ANY)
			return;

		var keyCode:Int = key;
		var wasDown:Bool = syncedKeys.exists(keyCode) && syncedKeys.get(keyCode);
		if (wasDown == down)
			return;

		@:privateAccess FlxG.keys.updateKeyStates(keyCode, down);
		syncedKeys.set(keyCode, down);
	}

	override function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?isLane:Bool = false):BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		shape.graphics.lineStyle(10, Color, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	override public function createHint(name:Array<String>, uniqueID:Int, x:Float, y:Float, width:Int, height:Int, color:Int = 0xFFFFFF, ?returned:String):MobileButton
	{
		var hint:MobileButton = new MobileButton(x, y, returned);
		hint.loadGraphic(createHintGraphic(width, height, color));

		if (showHints) {
			var doHeightFix:Bool = false;
			if (height == 144) doHeightFix = true;

			//Up Hint
			hint.hintUp = new FlxSprite();
			hint.hintUp.loadGraphic(createHintGraphic(width, Math.floor(height * (doHeightFix ? 0.060 : 0.020)), color, true));
			hint.hintUp.x = x;
			hint.hintUp.y = hint.y;

			//Down Hint
			hint.hintDown = new FlxSprite();
			hint.hintDown.loadGraphic(createHintGraphic(width, Math.floor(height * (doHeightFix ? 0.060 : 0.020)), color, true));
			hint.hintDown.x = x;
			hint.hintDown.y = hint.y + hint.height / (doHeightFix ? 1.060 : 1.020);
		}

		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.IDs = name;
		hint.uniqueID = uniqueID;
		var keyboardKey:FlxKey = getKeyboardKey(returned, name);
		hint.onDown.callback = function()
		{
			syncKeyboardKey(keyboardKey, true);
			onButtonDown?.dispatch(hint, name, uniqueID);
			if (hint.alpha != alpha)
				hint.alpha = alpha;
			if ((hint.hintUp?.alpha != 0.00001 || hint.hintDown?.alpha != 0.00001) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = 0.00001;
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			syncKeyboardKey(keyboardKey, false);
			onButtonUp?.dispatch(hint, name, uniqueID);
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
			if ((hint.hintUp?.alpha != alpha || hint.hintDown?.alpha != alpha) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = alpha;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	override function destroy():Void
	{
		if (syncedKeys != null)
			for (keyCode=>isDown in syncedKeys)
				if (isDown)
					@:privateAccess FlxG.keys.updateKeyStates(keyCode, false);
		syncedKeys = null;
		super.destroy();
	}
}
