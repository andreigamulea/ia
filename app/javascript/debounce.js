
function debounce(func, wait) {
    let timeout;
  
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
  
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
  
  document.addEventListener('turbo:load', () => {
    const searchForm = document.getElementById('search-form');
    const searchInput = searchForm.querySelector('input[name="query"]');
  
    const searchHandler = (event) => {
      searchForm.requestSubmit();
    };
  
    const debouncedSearchHandler = debounce(searchHandler, 300);
  
    searchInput.addEventListener('input', debouncedSearchHandler);
  });
  