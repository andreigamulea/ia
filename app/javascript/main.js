document.addEventListener('click', function(event) {
    const resetAndSubmitBtn = document.getElementById('reset-and-submit');
    if (event.target === resetAndSubmitBtn) {
      console.log("click merge js");
      const form = document.querySelector('#pas form');
      const textField = form.querySelector('input[type="text"]');
      
      // Verificați dacă valoarea câmpului de căutare este goală
      if (textField.value !== '') {
        textField.value = '';
      }
  
      // Trimiteți formularul
      form.dispatchEvent(new Event('submit', { cancelable: true }));
    }
  });

  
  
  