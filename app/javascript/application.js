// app/javascript/application.js

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick";
import "Chart.bundle";
import "ahoy";

document.addEventListener("DOMContentLoaded", function() {
    // Verifică dacă utilizatorul a acceptat cookie-urile
    if (!Cookies.get('cookiesAccepted')) {
        // Dacă utilizatorul nu a acceptat cookie-urile, afișează banner-ul
        document.getElementById('cookie-law-banner').style.display = 'block';
    }

    // Atunci când utilizatorul dă click pe butonul "Accept",
    // ascunde banner-ul și setează un cookie pentru a ține minte că utilizatorul a acceptat cookie-urile
    document.getElementById('cookie-law-accept').addEventListener('click', function() {
        document.getElementById('cookie-law-banner').style.display = 'none';
        Cookies.set('cookiesAccepted', 'true', { expires: 365 });
    });

    // Atunci când utilizatorul dă click pe butonul "Setări",
    // afișează fereastra de setări a cookie-urilor
    document.getElementById('cookie-law-settings').addEventListener('click', function() {
        document.getElementById('cookie-settings-window').style.display = 'block';
    });

    // Atunci când utilizatorul dă click pe butonul "Salvează" în fereastra de setări a cookie-urilor,
    // salvează setările în cookie-uri
    document.getElementById('cookie-settings-save').addEventListener('click', function() {
        var necessaryChecked = document.getElementById('cookie-settings-necessary').checked;
        var functionalityChecked = document.getElementById('cookie-settings-functionality').checked;
        var performanceChecked = document.getElementById('cookie-settings-performance').checked;
        var analyticsChecked = document.getElementById('cookie-settings-analytics').checked;
        var marketingChecked = document.getElementById('cookie-settings-marketing').checked;
        var otherChecked = document.getElementById('cookie-settings-other').checked;

        Cookies.set('necessaryCookiesAccepted', necessaryChecked, { expires: 365 });
        Cookies.set('functionalityCookiesAccepted', functionalityChecked, { expires: 365 });
        Cookies.set('performanceCookiesAccepted', performanceChecked, { expires: 365 });
        Cookies.set('analyticsCookiesAccepted', analyticsChecked, { expires: 365 });
        Cookies.set('marketingCookiesAccepted', marketingChecked, { expires: 365 });
        Cookies.set('otherCookiesAccepted', otherChecked, { expires: 365 });

        // Ascunde fereastra de setări a cookie-urilor
        document.getElementById('cookie-settings-window').style.display = 'none';

        // Ascunde și banner-ul de acceptare a cookie-urilor
        document.getElementById('cookie-law-banner').style.display = 'none';
        
        // Setează un cookie pentru a ține minte că utilizatorul a acceptat cookie-urile
        Cookies.set('cookiesAccepted', 'true', { expires: 365 });
    });
});
