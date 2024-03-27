function toggleMobileMenu() {
    const menu = document.getElementById("navMenu");
    const iconInactive = document.getElementById("menuTogglerIconInactive");
    const iconActive = document.getElementById("menuTogglerIconActive");

    menu.classList.toggle("show");

    if (menu.classList.contains("show")) {
        iconInactive.style.display = "none";
        iconActive.style.display = "block";
    } else {
        iconInactive.style.display = "block";
        iconActive.style.display = "none";
    }
}
