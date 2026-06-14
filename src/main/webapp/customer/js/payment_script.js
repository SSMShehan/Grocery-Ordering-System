


// TIMER COUNTDOWN 
const timer = document.querySelector('[data-id=timer]');
let timeLeft = 5 * 60 + 1;

const tick = () => {
  if (timeLeft > 0) {
    timeLeft--;
    const date = new Date('2000-01-01 00:00:00');
    date.setSeconds(timeLeft);
    const str = date.toISOString();
    timer.children[0].innerText = str[14];
    timer.children[1].innerText = str[15];
    timer.children[3].innerText = str[17];
    timer.children[4].innerText = str[18];
  }
}

setInterval(() => { tick(); }, 1000);
tick();
