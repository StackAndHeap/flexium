package be.stackandheap.flexium {

import be.stackandheap.flexium.actions.Actions;
import be.stackandheap.flexium.parser.AppParser;

import flash.display.Sprite;
import flash.external.ExternalInterface;

import mx.events.FlexEvent;

[Mixin]
public class Flexium extends Sprite {
    private static var flexium:Flexium;
    public static var application:Object;
    public var appParser:AppParser;
    private var _actions:Actions;

    public function Flexium(app:Object) {
        super();
        app.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
    }

    public static function init(systemRoot:Object):void {
        if(!flexium) {
            application = systemRoot;
            flexium = new Flexium(systemRoot);
        }
    }

    private function applicationCompleteHandler(event:FlexEvent):void {
        application.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
        appParser = new AppParser(application.getChildAt(0));
        appParser.setTooltipsToID();
        injectJavaScript();
        _actions = new Actions(appParser);

    }

    private function injectJavaScript():void {
        ExternalInterface.call("function () { var bob = " +
                "document.createElement('span'); bob.id = 'isSWFReady';" +
                "document.getElementsByTagName('html')[0].appendChild(bob);" +
                "}");

        var appId:String = appParser.thisApp.name;
        appId = appId.substring(0, appId.length-1);

        var myJavaScript:XML = <script>
            <![CDATA[
        		    function(id){

                		flexApp = id;
                		curMouseX = 0;
                		curMouseY = 0;

                		contextMenuIsVisible = false;
                		var menu = document.createElement("div");
						menu.setAttribute('id', 'sel-flex-context-menu');
						menu.setAttribute('class', 'right-click-menu');
						menu.style.position = "absolute";
						menu.style.visibility = "hidden";
						document.body.appendChild(menu);

                		doOnClick = function (event) {
                			if (event.button != 0 && event.target.id == flexApp) {
                				killEvents(event);
		    					curMouseX = event.clientX;
		    					curMouseY = event.clientY;

                				contextMenuIsVisible = true;
                				var flashObj = document.getElementById(flexApp);
                				flashObj["doFlexRightClick"]("","");
		    				} else if (event.button == 0 && event.target.id == flexApp && contextMenuIsVisible) {
		    					killEvents(event);
		    					var rightMenu = document.getElementById("sel-flex-context-menu");
								rightMenu.style.visibility = "hidden";
								contextMenuIsVisible = false;
		    				}
                		}

                		sendToSeIDE = function (event, objId, command) {
                			killEvents(event);
                			var rightMenu = document.getElementById("sel-flex-context-menu");
							rightMenu.style.visibility = "hidden";
							var evt = document.createEvent('MutationEvents');
							evt.initMutationEvent('flexSendCommandToSeIDE', true, true, document.createTextNode(''), objId, command , 'value', MutationEvent.MODIFICATION);
							document.dispatchEvent(evt);
							contextMenuIsVisible = false;
						}

						killEvents = function(event) {
							if (event.stopPropagation) { event.stopPropagation(); }
							if (event.preventDefault) { event.preventDefault(); }
							if (event.preventCapture) { event.preventCapture(); }
		    				if (event.preventBubble) { event.preventBubble(); }
						}

						document.getElementById(flexApp).wmode = "transparent";
                		document.addEventListener("mousedown", doOnClick, true);

               	}
        		]]>
        </script>

        ExternalInterface.call(myJavaScript , appId);
    }
}
}
