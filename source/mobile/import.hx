#if !macro
import funkin.options.Options;
import mobile.objects.FunkinHitbox;
import mobile.objects.FunkinJoyStick;
import funkin.backend.utils.NativeAPI;
import mobile.objects.FunkinMobilePad;
import funkin.backend.assets.ModsFolder;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.Tools as AndroidTools;
#end

#end
