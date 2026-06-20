package mobile.backend;

import flixel.FlxG;
import lime.math.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

@:keep
class SoftKeyboardInput
{
	static var field:TextField;

	static function ensureField():TextField
	{
		if (field != null)
			return field;

		field = new TextField();
		field.type = TextFieldType.INPUT;
		field.selectable = true;
		field.multiline = false;
		field.wordWrap = false;
		field.border = true;
		field.background = true;
		field.borderColor = 0xFFFFFF;
		field.backgroundColor = 0x000000;
		field.textColor = 0xFFFFFF;
		field.defaultTextFormat = new TextFormat("_sans", 24, 0xFFFFFF, true);
		field.needsSoftKeyboard = true;
		return field;
	}

	public static function open(x:Float, y:Float, width:Float, height:Float, ?text:String = "", ?maxChars:Int = 32, ?restrict:String = null):Void
	{
		var input = ensureField();
		input.x = x;
		input.y = y;
		input.width = width;
		input.height = height;
		input.maxChars = maxChars;
		input.restrict = restrict;
		input.text = text;
		input.visible = true;

		var stage = FlxG.stage;
		if (stage == null)
			return;

		if (input.parent == null)
			stage.addChild(input);

		stage.focus = input;

		try {
			stage.window.setTextInputRect(new Rectangle(x, y, width, height));
			stage.window.textInputEnabled = true;
		} catch (e:Dynamic) {
			trace('Could not enable soft keyboard text input: $e');
		}

		try {
			input.requestSoftKeyboard();
		} catch (e:Dynamic) {
			trace('Could not request soft keyboard: $e');
		}
	}

	public static function getText():String
	{
		return field == null ? "" : field.text;
	}

	public static function setText(value:String):Void
	{
		if (field != null)
			field.text = value;
	}

	public static function close():Void
	{
		if (field == null)
			return;

		var stage = FlxG.stage;
		if (stage != null)
		{
			if (stage.focus == field)
				stage.focus = null;

			try {
				stage.window.textInputEnabled = false;
			} catch (e:Dynamic) {
				trace('Could not disable soft keyboard text input: $e');
			}
		}

		if (field.parent != null)
			field.parent.removeChild(field);
	}
}
