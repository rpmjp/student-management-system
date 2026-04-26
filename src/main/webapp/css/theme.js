(function() {
    function getPreferred() {
        var saved = localStorage.getItem('sms-theme');
        if (saved) return saved;
        return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    }

    function apply(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('sms-theme', theme);
        var btn = document.getElementById('themeToggle');
        if (btn) btn.textContent = theme === 'dark' ? '\u2600' : '\u263E';
    }

    apply(getPreferred());

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function(e) {
        if (!localStorage.getItem('sms-theme')) {
            apply(e.matches ? 'dark' : 'light');
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('themeToggle');
        if (btn) {
            btn.addEventListener('click', function() {
                var current = document.documentElement.getAttribute('data-theme');
                apply(current === 'dark' ? 'light' : 'dark');
            });
        }
    });
})();