package be.stackandheap.flexium.socket {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.Socket;

public class AirComLink extends EventDispatcher{

    private var socket:Socket;
    private var host:String;
    private var port:int;

    public function AirComLink(host:String, port:int){
        this.host = host;
        this.port = port;
    }

    public function connect():void {
        try{
            socket=new Socket();
            socket.addEventListener(Event.CONNECT, socket_connectHandler);
            socket.connect(host, port);
        }catch(e:IOErrorEvent){
            this.dispatchEvent(new Event(AirComEvent.ERROR,'Could not establish connection with server'));
        }
    }
    public function close():void{
        try{
            if (socket && socket.connected) {
                socket.writeUTFBytes("offline\r\n");
                socket.flush();
                socket.close();
            }
        }catch(e:IOErrorEvent){
            this.dispatchEvent(new Event(AirComEvent.ERROR,'Could not close connection with server'));
        }
    }
    public function sendToSocket(msg:String):void {
        try{
            socket.writeUTFBytes(msg + "\r\n");
            socket.flush();
        }catch(e:IOErrorEvent){
            this.dispatchEvent(new Event(AirComEvent.ERROR,'Could not send data to server'));
        }
    }

    private function socket_connectHandler(event:Event):void {
        this.dispatchEvent(new AirComEvent(AirComEvent.CONNECTED));
        socket.addEventListener(ProgressEvent.SOCKET_DATA, socket_dataHandler);
        socket.addEventListener(Event.CLOSE, socket_closeHandler);
    }

    private function socket_dataHandler(event:ProgressEvent):void {
        var s:String="";
        while (socket.bytesAvailable) {
            s+=socket.readUTFBytes(socket.bytesAvailable);
        }
        this.dispatchEvent(new AirComEvent(AirComEvent.RECEIVED_DATA,s));
    }

    private function socket_closeHandler(event:Event):void {
        this.dispatchEvent(new AirComEvent(AirComEvent.CLOSED));
    }
}
}
