document.addEventListener('DOMContentLoaded', () => {
    
    // --- 1. Flash Sale Countdown ---
    const timerBox = document.querySelector('.timer-box');
    if (timerBox) {
        // Set end time to 24 hours from now
        let endTime = new Date();
        endTime.setHours(endTime.getHours() + 24); 

        function updateTimer() {
            const now = new Date();
            const diff = endTime - now;

            if (diff <= 0) {
                // Reset or remove
                return;
            }

            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            // Populate spans
            timerBox.innerHTML = `
                <div class="time-unit">${hours < 10 ? '0'+hours : hours}</div>
                <div class="time-unit">:</div>
                <div class="time-unit">${minutes < 10 ? '0'+minutes : minutes}</div>
                <div class="time-unit">:</div>
                <div class="time-unit">${seconds < 10 ? '0'+seconds : seconds}</div>
            `;
        }
        setInterval(updateTimer, 1000);
        updateTimer();
    }

    // --- 2. Scroll Animations (Intersection Observer) ---
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate__animated', 'animate__fadeInUp');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Elements to animate
    document.querySelectorAll('.cat-card, .flash-card, .prod-card-modern, .feature-box, .offer-card').forEach(el => {
        el.style.opacity = '0'; // Hide initially
        // Delay logic for grids
        observer.observe(el);
        
        // Add listener to remove opacity after animation start
        el.addEventListener('animationstart', () => {
            el.style.opacity = '1';
        });
    });

    // Specific Entrance for Offer Banner
    const banner = document.querySelector('.offer-parallax');
    if (banner) {
        window.addEventListener('scroll', () => {
            const scrolled = window.scrollY;
            const rate = scrolled * 0.5;
            banner.style.backgroundPosition = `center ${rate}px`;
        });
    }

    // --- 3. Add to Cart Toast Notification ---
    const buttons = document.querySelectorAll('.btn-add-cart-full, .p-add-btn');
    buttons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            // e.preventDefault(); // Don't prevent default if it submits a form
            
            // Create Toast
            const toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.innerHTML = `<i class="fas fa-check-circle"></i> Added to Cart!`;
            
            // Basic Toast Styles
            Object.assign(toast.style, {
                position: 'fixed',
                bottom: '20px',
                right: '20px',
                background: '#10B981',
                color: 'white',
                padding: '15px 30px',
                borderRadius: '50px',
                boxShadow: '0 10px 30px rgba(0,0,0,0.2)',
                zIndex: '9999',
                transform: 'translateY(100px)',
                transition: 'transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)'
            });

            document.body.appendChild(toast);
            
            // Trigger Animation
            setTimeout(() => {
                toast.style.transform = 'translateY(0)';
            }, 10);

            // Remove
            setTimeout(() => {
                toast.style.transform = 'translateY(100px)';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        });
    });

});
