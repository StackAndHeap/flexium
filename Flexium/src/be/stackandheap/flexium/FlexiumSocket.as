package be.stackandheap.flexium {
import be.stackandheap.flexium.socket.AirComEvent;
import be.stackandheap.flexium.socket.AirComLink;

import mx.controls.Alert;

public class FlexiumSocket {
    private var _link:AirComLink;

    public function FlexiumSocket(host:String = "localhost", port:int = 4444) {
        _link = new AirComLink(host,  port);
        _link.addEventListener(AirComEvent.CONNECTED, socketConnectHandler);
        _link.addEventListener(AirComEvent.RECEIVED_DATA, socketDataReceivedHandler);
        _link.addEventListener(AirComEvent.CLOSED, socketClosedHandler);
        _link.addEventListener(AirComEvent.ERROR, socketErrorHandler);
        _link.connect();
    }

    private function socketErrorHandler(event:AirComEvent):void {
        trace('error: '+event.data);
    }

    private function socketClosedHandler(event:AirComEvent):void {
        trace('server closed');
    }

    private function socketConnectHandler(event:AirComEvent):void {
        trace('connected');
        _link.sendToSocket('hi from app');
    }

    private function socketDataReceivedHandler(event:AirComEvent):void {
        Alert.show('data received' + event.data);
    }
}
}
