// Adiciona um event listener para aplicar mascara de dados com fomato dd/mm/YYYY, com no máximo 10 caracteres
document.addEventListener("input", function (event) {

  if (event.target.matches("input[data-validation=\"date\"]")) {

      var that = event.target;

      var element = that;

      var max_chars = 10;

      if (element.value.length > max_chars) {
          element.value = element.value.substr(0, max_chars);
      }

      var value = element.value;

      value = value.replace(/\D/g, ''); // Remove caracteres não numéricos
      value = value.replace(/^(\d{2})(\d)/g, '$1/$2'); // Insere a primeira barra
      value = value.replace(/^(\d{2})\/(\d{2})(\d)/g, '$1/$2/$3'); // Insere a segunda barra

      element.value = value;

  }

});
