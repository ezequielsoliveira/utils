-- Cria um socket TCP e associa ao endereço localhost e à porta 8080
local server = assert(socket.tcp())
assert(server:bind("localhost", 8080))
assert(server:listen())

while true do
  -- Espera por uma nova conexão de um cliente
  local client = assert(server:accept())
  
  -- Lê a requisição HTTP do cliente
  local request = ""
  while true do
    local chunk, err, partial = client:receive(1024)
    if err == "closed" then
      break
    end
    request = request .. chunk
    if partial == "" then
      break
    end
  end
  
  -- Processa a requisição HTTP e envia a resposta
  local response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\nHello, world!"
  client:send(response)
  
  -- Fecha a conexão com o cliente
  client:close()
end
