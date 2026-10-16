const menuToggle = document.querySelector('.menu-toggle');
const nav = document.querySelector('#main-nav');

if (menuToggle && nav) {
  menuToggle.addEventListener('click', () => {
    const isOpen = nav.classList.toggle('open');
    menuToggle.setAttribute('aria-expanded', String(isOpen));
    menuToggle.setAttribute('aria-label', isOpen ? 'Close navigation' : 'Toggle navigation');
  });

  nav.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      nav.classList.remove('open');
      menuToggle.setAttribute('aria-expanded', 'false');
      menuToggle.setAttribute('aria-label', 'Toggle navigation');
    });
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      nav.classList.remove('open');
      menuToggle.setAttribute('aria-expanded', 'false');
    }
  });
}


// Subtle pointer-following light on larger screens; touch devices keep the clean static look.
const hero = document.querySelector('.hero');
if (hero && window.matchMedia('(pointer: fine)').matches && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
  hero.addEventListener('pointermove', (event) => {
    const bounds = hero.getBoundingClientRect();
    hero.style.setProperty('--pointer-x', `${event.clientX - bounds.left}px`);
    hero.style.setProperty('--pointer-y', `${event.clientY - bounds.top}px`);
  }, { passive: true });
  hero.addEventListener('pointerleave', () => {
    hero.style.setProperty('--pointer-x', '72%');
    hero.style.setProperty('--pointer-y', '42%');
  }, { passive: true });
}
