package funkin.backend.system;

import flixel.FlxG;
import funkin.options.Options;

class MobilePerformance {
	#if mobile
	public static inline var MIN_ACTIVE_FPS:Int = 30;
	public static inline var MAX_ACTIVE_FPS:Int = 240;
	public static inline var BACKGROUND_FPS:Int = 5;

	static var focused:Bool = true;
	static var lastApplied:Int = -1;
	static var lastHadSubState:Bool = false;

	public static function init() {
		focused = true;
		lastApplied = -1;
		lastHadSubState = hasSubState();
		apply(true);
	}

	public static function onFocus() {
		focused = true;
		apply(true);
	}

	public static function onFocusLost() {
		focused = false;
		apply(true);
	}

	public static function update() {
		var subState = hasSubState();
		if (subState != lastHadSubState) {
			lastHadSubState = subState;
			apply(true);
			return;
		}

		var target = getTargetFramerate();
		if (target != lastApplied || FlxG.updateFramerate != target || FlxG.drawFramerate != target)
			apply(true);
	}

	public static function sanitizeUserFramerate(value:Int):Int {
		if (value < MIN_ACTIVE_FPS)
			return MIN_ACTIVE_FPS;
		if (value > MAX_ACTIVE_FPS)
			return MAX_ACTIVE_FPS;
		return value;
	}

	public static function apply(force:Bool = false) {
		var target = getTargetFramerate();
		if (!force && target == lastApplied)
			return;

		setFlixelFramerate(target);
		lastApplied = target;
	}

	static function getTargetFramerate():Int {
		if (!focused)
			return BACKGROUND_FPS;

		var target = sanitizeUserFramerate(Options.framerate);
		return target;
	}

	static inline function hasSubState():Bool {
		return FlxG.state != null && FlxG.state.subState != null;
	}

	static function setFlixelFramerate(value:Int) {
		if (value <= 0)
			return;

		if (FlxG.updateFramerate < value)
			FlxG.drawFramerate = FlxG.updateFramerate = value;
		else
			FlxG.updateFramerate = FlxG.drawFramerate = value;
	}
	#else
	public static inline function init() {}
	public static inline function onFocus() {}
	public static inline function onFocusLost() {}
	public static inline function update() {}
	public static inline function sanitizeUserFramerate(value:Int):Int return value;
	public static inline function apply(force:Bool = false) {}
	#end
}
