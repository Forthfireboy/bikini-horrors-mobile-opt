function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Set Default Cam Zoom") {
        switch(params[1]) {
            case "camGame": defaultCamZoom = params[0];
            case "camHUD": defaultHudZoom = params[0];
        }
    }
}