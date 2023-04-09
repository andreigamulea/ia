const debounce = (func, wait) => {
    let timeout;
    return function(...args) {
      const context = this;
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(context, args), wait);
    };
  };
  
  const searchInput = document.getElementById("search-input");
  const searchForm = document.getElementById("search-form");
  
  if (searchInput && searchForm) {
    searchInput.addEventListener(
      "input",
      debounce(() => {
        searchForm.requestSubmit();
      }, 20)
    );
  }
  