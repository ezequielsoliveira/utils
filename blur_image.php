<?php

// INFORMAÇÕES SOBRE ESSE SCRIPT
// Esse é um script para transformar uma imagem em desfocada, com base em uma intensidade informada.

// Define a intensidade do desfoque da imagem.
$intensity = 20;

// Caminho da imagem original.
$original_image_path = './image.jpg';
// Caminho da imagem desfocada que será gerada.
$blurred_image_path = './blurred_image.jpg';

// Carrega a imagem original.
$image = imagecreatefromjpeg($original_image_path);

// Aplica efeito de desfoque, utilizando um Convolução Gaussiana. A convolução é realizada em cada pixel da imagem e o resultado é uma imagem filtrada, onde cada pixel é substituído pela média ponderada dos valores dos pixels circundantes, de acordo com a matriz de convolução especificada.
for($i = 0; $i < $intensity; $i++) {
    $gaussian = array(array(1.0, 2.0, 1.0), array(2.0, 4.0, 2.0), array(1.0, 2.0, 1.0));
    imageconvolution($image, $gaussian, 16, 0);
}

// Salva a nova imagem desfocada no caminho especificado.
imagejpeg($image, $blurred_image_path);

// Libera a memoria utilizada pela imagem.
imagedestroy($image);
