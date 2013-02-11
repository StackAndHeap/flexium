package be.stackandheap.flexiumLink;

import java.net.ServerSocket;
import java.net.Socket;

public class FlexiumServer extends Thread {
    private ServerSocket dateServer;

    public FlexiumServer(Integer port) throws Exception {
        dateServer = new ServerSocket(port);
        System.out.println("Server listening on port 4444.");
        this.start();
    }

    public void run() {
        while (true) {
            try {
                System.out.println("Waiting for connections.");
                Socket client = dateServer.accept();
                System.out.println("Accepted a connection from: "
                        + client.getInetAddress());
                Connection connection = new Connection(client);
                connection.sendMessage("Server says HI!");
            } catch (Exception e) {
                System.out.println(e);
            }
        }
    }
}