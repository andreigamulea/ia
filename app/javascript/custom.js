document.addEventListener('turbolinks:load', () => {
    const searchForm = document.getElementById('search_form');
    const searchField = searchForm.querySelector('input[name="q[aliment_cont]"]');
  
    if (searchField) {
      const debounceTime = 500;
      searchField.addEventListener('input', debounce(() => {
        searchForm.requestSubmit();
      }, debounceTime));
    }
  });
  