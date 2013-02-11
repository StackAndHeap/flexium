package be.stackandheap.flexiumLink;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;

class Connection extends Thread {
    private Socket client = null;
    private OutputStreamWriter oos = null;
    private BufferedReader in = null;

    public Connection(Socket clientSocket) {
        client = clientSocket;
        try {
            in = new BufferedReader(new InputStreamReader(client.getInputStream()));
            oos = new OutputStreamWriter(client.getOutputStream());
        } catch (Exception e1) {
            System.out.println(e1);
            try {
                client.close();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
            return;
        }
        this.start();
    }
    public void run() {
        String line;
        while (!client.isClosed()) {
            try {
                line = in.readLine();
                System.out.println(line);
                if ("sendme".equals(line)) {
                    sendMessage("Arthur N Neves hello!");
                }
                if ("offline".equals(line)) {
                    kill();
                }
            } catch (IOException e) {
                System.out.println("Read failed");
                System.exit(-1);
            }
        }
    }
    public void sendMessage(String msg) {
        try {
            oos.write(msg);
            oos.flush();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    public void kill() throws IOException {
        client.close();
    }
}
