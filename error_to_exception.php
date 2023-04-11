<?php

// Define o manipulador de erros para lançar exceções.
set_error_handler(function (int $errno, string $errstr, string $errfile, int $errline) {
    throw new \Exception($errstr, $errno, $errfile, $errline);
});

// Define o manipulador de erros para mostrar o objeto da exceção com `var_dump`.
set_exception_handler(function ($exception) {
    var_dump($exception);
});
