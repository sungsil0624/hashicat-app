#!/bin/bash
# Copyright (c) HashiCorp, Inc.

# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

cat << EOM > /var/www/html/index.html
<html>
  <head>
    <title>GLUE</title>
    <style>
      body {
  font-family: 'Helvetica Neue', Arial, sans-serif;
  background-color: #ececec;
  color: #333;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  margin: 0;
  overflow: hidden;
}

.container {
  max-width: 800px;
  background-color: #fff;
  padding: 30px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  text-align: center;
  position: relative;
  z-index: 1;
}

h1 {
  color: #ff6347;
  font-size: 2.5em;
  margin-bottom: 20px;
}

p {
  font-size: 1.2em;
  margin-bottom: 20px;
}

img {
  max-width: 100%;
  height: auto;
  border-radius: 10px;
  transition: transform 0.2s;
}

img:hover {
  transform: scale(1.05);
}

canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
    </style>
  </head>
  <body>
    <canvas id="fireworksCanvas"></canvas>
    <div class="container">
      <!-- BEGIN -->
      <img src="https://plug-img-bucket.s3.us-west-1.amazonaws.com/KakaoTalk_Photo_2024-05-24-13-54-42.jpeg" alt="Image">
      <h1>GLUE World!</h1>
      <p>Welcome to Team DoTheZ!</p>
      <!-- END -->
    </div>
    <script src="script.js">
      (function() {
  const canvas = document.getElementById('fireworksCanvas');
  const ctx = canvas.getContext('2d');
  let fireworks = [];
  let particles = [];
  const numberOfLaunches = 20; // Adjust the number of fireworks launches

  function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  }

  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();

  class Firework {
    constructor(startX, startY, targetX, targetY) {
      this.x = startX;
      this.y = startY;
      this.startX = startX;
      this.startY = startY;
      this.targetX = targetX;
      this.targetY = targetY;
      this.distanceToTarget = this.calculateDistance(startX, startY, targetX, targetY);
      this.distanceTraveled = 0;
      this.coordinates = [];
      this.coordinateCount = 3;
      while (this.coordinateCount--) {
        this.coordinates.push([this.x, this.y]);
      }
      this.angle = Math.atan2(targetY - startY, targetX - startX);
      this.speed = 2;
      this.acceleration = 1.05;
      this.brightness = Math.random() * 50 + 50;
      this.targetRadius = 1;
    }

    update(index) {
      this.coordinates.pop();
      this.coordinates.unshift([this.x, this.y]);
      if (this.targetRadius < 8) {
        this.targetRadius += 0.3;
      } else {
        this.targetRadius = 1;
      }
      this.speed *= this.acceleration;
      const vx = Math.cos(this.angle) * this.speed;
      const vy = Math.sin(this.angle) * this.speed;
      this.distanceTraveled = this.calculateDistance(this.startX, this.startY, this.x + vx, this.y + vy);
      if (this.distanceTraveled >= this.distanceToTarget) {
        createParticles(this.targetX, this.targetY);
        fireworks.splice(index, 1);
      } else {
        this.x += vx;
        this.y += vy;
      }
    }

    draw() {
      ctx.beginPath();
      ctx.moveTo(this.coordinates[this.coordinates.length - 1][0], this.coordinates[this.coordinates.length - 1][1]);
      ctx.lineTo(this.x, this.y);
      ctx.strokeStyle = `hsl(${Math.random() * 360}, 100%, ${this.brightness}%)`;
      ctx.stroke();
      ctx.beginPath();
      ctx.arc(this.targetX, this.targetY, this.targetRadius, 0, Math.PI * 2);
      ctx.stroke();
    }

    calculateDistance(x1, y1, x2, y2) {
      const xDistance = x2 - x1;
      const yDistance = y2 - y1;
      return Math.sqrt(xDistance * xDistance + yDistance * yDistance);
    }
  }

  class Particle {
    constructor(x, y) {
      this.x = x;
      this.y = y;
      this.coordinates = [];
      this.coordinateCount = 5;
      while (this.coordinateCount--) {
        this.coordinates.push([this.x, this.y]);
      }
      this.angle = Math.random() * Math.PI * 2;
      this.speed = Math.random() * 10 + 1;
      this.friction = 0.95;
      this.gravity = 1;
      this.hue = Math.random() * 360;
      this.brightness = Math.random() * 80 + 50;
      this.alpha = 1;
      this.decay = Math.random() * 0.03 + 0.01;
    }

    update(index) {
      this.coordinates.pop();
      this.coordinates.unshift([this.x, this.y]);
      this.speed *= this.friction;
      this.x += Math.cos(this.angle) * this.speed;
      this.y += Math.sin(this.angle) * this.speed + this.gravity;
      this.alpha -= this.decay;
      if (this.alpha <= this.decay) {
        particles.splice(index, 1);
      }
    }

    draw() {
      ctx.beginPath();
      ctx.moveTo(this.coordinates[this.coordinates.length - 1][0], this.coordinates[this.coordinates.length - 1][1]);
      ctx.lineTo(this.x, this.y);
      ctx.strokeStyle = `hsla(${this.hue}, 100%, ${this.brightness}%, ${this.alpha})`;
      ctx.stroke();
    }
  }

  function createParticles(x, y) {
    let particleCount = 30;
    while (particleCount--) {
      particles.push(new Particle(x, y));
    }
  }

  function launchFireworks() {
    for (let i = 0; i < numberOfLaunches; i++) {
      const startX = Math.random() * canvas.width;
      const startY = canvas.height;
      const targetX = Math.random() * canvas.width;
      const targetY = Math.random() * canvas.height / 2;
      fireworks.push(new Firework(startX, startY, targetX, targetY));
    }
  }

  function loop() {
    requestAnimationFrame(loop);
    ctx.globalCompositeOperation = 'destination-out';
    ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.globalCompositeOperation = 'lighter';

    fireworks.forEach((firework, index) => {
      firework.draw();
      firework.update(index);
    });

    particles.forEach((particle, index) => {
      particle.draw();
      particle.update(index);
    });
  }

  launchFireworks();
  setInterval(launchFireworks, 2000); // Launch fireworks every 2 seconds
  loop();
})();

    </script>
  </body>


</html>
EOM

echo "Script complete."