package build;

import sys.io.File;
import sys.FileSystem;
import haxe.ds.StringMap;
import lime.project.Icon;
import lime.project.Platform;
import lime.project.PlatformType;
import lime.tools.helpers.PathHelper;
import lime.tools.helpers.LogHelper;

using Lambda;

class AssetFinder {

	public static function getSounds(soundDir:String, platform:Platform, platformType:PlatformType):Map<String,String> {
        var sounds = new StringMap();

		var soundExt = switch (platformType) {
            case PlatformType.WEB:
				sounds.set("soundTheme", soundDir + "/theme.mp3");
                "mp3";
            default:
				sounds.set("soundTheme", soundDir + "/theme.ogg");
                "wav";
        }

		FileSystem.readDirectory(soundDir)
			.iter(function (i:String) {
				var idRx = new EReg("(^[0-9]+)(\\." + soundExt  + ")", "ig");
				if (!idRx.match(i)) {
					LogHelper.info("", i + " not matched");
					return;
				}

				var num = idRx.matched(1);
				sounds.set("sound"+num, soundDir + "/" + i );
			});

		return sounds;
	}

    public static function getMobileIcons(iconDir:String):Array<Icon> {
        var icons = new Array<Icon>();

		FileSystem.readDirectory(iconDir)
			.iter(function (i:String) {
				var sizeRx = ~/(^[0-9]+)(\.png)/ig;
				if (!sizeRx.match(i)) return;

				var size = sizeRx.matched(1);

				LogHelper.info("", "Using " + i + " for icon size " + size);
				icons.push(new lime.project.Icon(iconDir + i, Std.parseInt(size)));
			});

        return icons;
    }
}