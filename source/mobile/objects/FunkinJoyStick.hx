package mobile.objects;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import funkin.backend.assets.ModsFolder;
import openfl.utils.Assets;
import openfl.display.BitmapData;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

import mobile.JoyStick;
import mobile.MobileButton;

using StringTools;

class FunkinJoyStick extends JoyStick {
	//FNF Asset Stuff
	override private function loadObjectGraphic(object:FlxSprite, graphic:String, img:String) {
		var fixedModPath:String = graphic;
		if (!graphic.startsWith(MobileConfig.mobileFolderPath))
			graphic = MobileConfig.mobileFolderPath + graphic;

		#if MOD_SUPPORT
		final moddyFolder:String = ModsFolder.getCurrentModAssetPath('mobile');
		#end

		#if MOD_SUPPORT
		var xmlGraphicExists:Bool = FileSystem.exists('$graphic.xml') && FileSystem.exists('$graphic.png');
		var modGraphicXml:String = moddyFolder != null ? '$moddyFolder/$fixedModPath.xml' : null;
		var modGraphicPng:String = moddyFolder != null ? '$moddyFolder/$fixedModPath.png' : null;
		var modGraphicAstc:String = moddyFolder != null ? '$moddyFolder/$fixedModPath.astc' : null;
		var modGraphicExists:Bool = (modGraphicPng != null && ModsFolder.assetPathExists(modGraphicPng))
			|| (modGraphicAstc != null && ModsFolder.assetPathExists(modGraphicAstc));
		if (modGraphicXml != null && modGraphicPng != null && ModsFolder.assetPathExists(modGraphicXml) && modGraphicExists) {
			if (tryLoadAtlasFrame(object, modGraphicPng, modGraphicXml, img))
				return;

			makeFallbackGraphic(object, img);
		}
		else if (xmlGraphicExists)
			object.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow(BitmapData.fromBytes(File.getBytes('$graphic.png')), File.getContent('$graphic.xml')).getByName(img)));
		else #end {
			var assetGraphic:String = '$graphic.png';
			var assetXml:String = '$graphic.xml';
			if (!tryLoadAtlasFrame(object, assetGraphic, assetXml, img))
				makeFallbackGraphic(object, img);
		}
	}

	private function resolveAssetPath(path:String, tryAstc:Bool = false):String
	{
		if (path == null || path.length <= 0)
			return null;

		path = path.replace("\\", "/");
		var candidates:Array<String> = [path];
		if (!path.startsWith("assets/"))
			candidates.push('assets/$path');

		if (tryAstc) {
			var current:Array<String> = candidates.copy();
			for (candidate in current)
				if (candidate.endsWith(".png"))
					candidates.push(candidate.substr(0, candidate.length - 4) + ".astc");
		}

		for (candidate in candidates)
			if (Assets.exists(candidate))
				return candidate;

		return null;
	}

	private function tryLoadAtlasFrame(object:FlxSprite, imagePath:String, xmlPath:String, img:String):Bool
	{
		try {
			#if sys
			if (FileSystem.exists(imagePath) && FileSystem.exists(xmlPath)) {
				var fileFrames = FlxAtlasFrames.fromSparrow(BitmapData.fromBytes(File.getBytes(imagePath)), File.getContent(xmlPath));
				var fileFrame = fileFrames.getByName(img);
				if (fileFrame != null) {
					object.loadGraphic(FlxGraphic.fromFrame(fileFrame));
					return true;
				}
			}
			#end

			var resolvedImage = resolveAssetPath(imagePath, true);
			var resolvedXml = resolveAssetPath(xmlPath, false);
			if (resolvedImage == null || resolvedXml == null)
				return false;

			// ASTC textures are GPU-only in this port. They work for whole sprites,
			// but atlas sub-frame extraction can report success while drawing blank.
			// For joystick controls, a visible generated fallback is better.
			if (resolvedImage.toLowerCase().endsWith(".astc"))
				return false;

			var frames = FlxAtlasFrames.fromSparrow(Assets.getBitmapData(resolvedImage), Assets.getText(resolvedXml));
			var frame = frames.getByName(img);
			if (frame == null)
				return false;

			object.loadGraphic(FlxGraphic.fromFrame(frame));
			return true;
		} catch (e:Dynamic) {
			return false;
		}
	}

	private function makeFallbackGraphic(object:FlxSprite, img:String):Void
	{
		var size:Int = img == "thumb" ? 84 : 200;
		object.makeGraphic(size, size, FlxColor.TRANSPARENT);
		if (img == "thumb")
			FlxSpriteUtil.drawCircle(object, size / 2, size / 2, size / 2, FlxColor.WHITE);
		else {
			FlxSpriteUtil.drawCircle(object, size / 2, size / 2, size / 2, 0x77000000);
			FlxSpriteUtil.drawCircle(object, size / 2, size / 2, (size / 2) - 5, FlxColor.TRANSPARENT, {thickness: 5, color: FlxColor.WHITE});
		}
		object.updateHitbox();
	}

	public function refreshVisuals(visualAlpha:Float = 1, ?targetCamera:FlxCamera):Void
	{
		visible = true;
		active = true;
		alpha = visualAlpha;

		if (base != null) {
			if (base.graphic == null || base.width <= 1 || base.height <= 1)
				makeFallbackGraphic(base, "base");
			base.visible = true;
			base.active = true;
			base.alpha = 1;
			base.isJoyStick = true;
			base.scrollFactor.set();
			base.updateHitbox();
			if (targetCamera != null)
				base.cameras = [targetCamera];
		}

		if (thumb != null) {
			if (thumb.graphic == null || thumb.width <= 1 || thumb.height <= 1)
				makeFallbackGraphic(thumb, "thumb");
			thumb.visible = true;
			thumb.active = true;
			thumb.alpha = 1;
			thumb.scrollFactor.set();
			if (targetCamera != null)
				thumb.cameras = [targetCamera];
			recenterThumb();
		}
	}

	private function recenterThumb():Void
	{
		if (base == null || thumb == null)
			return;

		thumb.x = base.x + ((base.width - thumb.width) * 0.5);
		thumb.y = base.y + ((base.height - thumb.height) * 0.5);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		resetReleasedBaseInput();
	}

	private function resetReleasedBaseInput():Void
	{
		if (base == null)
			return;

		@:privateAccess
		if (_activeTouch == null && (base.pressed || base.status != MobileButton.NORMAL || base.currentInput != null))
			base.onUpHandler();
	}

	public function new(x:Float = 0, y:Float = 0, ?graphic:String, ?onMove:Float->Float->Float->String->Void)
	{
		super(x, y, graphic, onMove);
		refreshVisuals(1);
	}
}
