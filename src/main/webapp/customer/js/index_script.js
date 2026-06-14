let currentIndex = 0;
const slides = document.querySelectorAll(".slide");

function showSlides() {
    
    slides.forEach(slide => slide.style.display = "none");

    
    currentIndex++;
    if (currentIndex > slides.length) { currentIndex = 1; }

   
    slides[currentIndex - 1].style.display = "block";

   
    setTimeout(showSlides, 5000);
}


showSlides();
