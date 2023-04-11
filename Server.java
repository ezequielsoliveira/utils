import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

public class ServidorHTTP {

    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
        server.createContext("/", (HttpExchange t) -> {
            String response = "Exemplo de resposta do servidor HTTP!";
            String query = t.getRequestURI().getQuery();
            if (query != null) {
                String[] params = query.split("&");
                for (String param : params) {
                    String[] pair = param.split("=");
                    if (pair.length == 2) {
                        String key = pair[0];
                        String value = pair[1];
                        response += "\n" + key + ": " + value;
                    }
                }
            }
            try {
                t.sendResponseHeaders(200, response.length());
                OutputStream os = t.getResponseBody();
                os.write(response.getBytes());
                os.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
        server.setExecutor(null);
        server.start();
        System.out.println("Servidor iniciado em: http://localhost:8000/");
    }

}
