<template>
  <div id="app">
    <audio
      ref="sound1"
      src="https://s3.amazonaws.com/freecodecamp/simonSound1.mp3"
    ></audio>
    <audio
      ref="sound2"
      src="https://s3.amazonaws.com/freecodecamp/simonSound2.mp3"
    ></audio>
    <audio
      ref="sound3"
      src="https://s3.amazonaws.com/freecodecamp/simonSound3.mp3"
    ></audio>
    <audio
      ref="sound4"
      src="https://s3.amazonaws.com/freecodecamp/simonSound4.mp3"
    ></audio>
    <div id="simon">
      <div id="center">
        <div id="title">
          <h1>Simon</h1>
        </div>
        <div id="controls">
          <a id="start" class="btn" @click="start"></a>
          <div class="radio-group">
            Сложность
            <div>
              <input
                type="radio"
                id="I"
                name="drone"
                value="I"
                checked
                @click="toggleSpeed('I')"
              />
              <label for="I">I</label>
            </div>
            <div>
              <input
                type="radio"
                id="II"
                name="drone"
                value="II"
                @click="toggleSpeed('II')"
              />
              <label for="II">II</label>
            </div>
            <div>
              <input
                type="radio"
                id="III"
                name="drone"
                value="III"
                @click="toggleSpeed('III')"
              />
              <label for="III">III</label>
            </div>
          </div>
          <div id="counter">
            <span
              :class="{ lit: power }"
              v-text="showError ? '! lose !' : showWin ? '* *' : displayCount"
            ></span>
          </div>
        </div>
        <div id="power">
          <p>Off</p>
          <div id="switch" :class="{ on: power }" @click="togglePower"></div>
          <p>On</p>
        </div>
      </div>
      <div id="buttons">
        <div
          class="button"
          :class="{ highlight: hlGreen }"
          id="green"
          @click="input(1)"
        ></div>
        <div
          class="button"
          :class="{ highlight: hlRed }"
          id="red"
          @click="input(2)"
        ></div>
        <div
          class="button"
          :class="{ highlight: hlYellow }"
          id="yellow"
          @click="input(3)"
        ></div>
        <div
          class="button"
          :class="{ highlight: hlBlue }"
          id="blue"
          @click="input(4)"
        ></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "app",
  data: function () {
    return {
      delay: 1500,
      power: false,
      started: false,
      count: 0,
      series: [],
      playingSeries: false,
      userInput: [],
      hlRed: false,
      hlGreen: false,
      hlYellow: false,
      hlBlue: false,
      allowInput: false,
      showError: false,
      showWin: false,
      totalToWin: 20,
    };
  },
  computed: {
    displayCount() {
      if (this.count == 0) return "- -";
      else return this.count;
    },
  },
  methods: {
    reset() {
      this.started = false;
      this.count = 0;
      this.series = [];
      this.userInput = [];
      this.allowInput = false;
      this.playingSeries = false;
      this.showError = false;
      this.showWin = false;
      this.hlGreen = false;
      this.hlRed = false;
      this.hlYellow = false;
      this.hlBlue = false;
    },
    winner() {
      this.showWin = true;
      let self = this;
      let delay = 500;
      this.hlGreen = true;
      for (let x = 1; x <= 6; x++) {
        setTimeout(function () {
          self.playTone(1);
        }, delay);
        if (x == 6)
          setTimeout(function () {
            self.hlGreen = false;
            self.showWin = false;
            self.reset();
          }, delay + 500);
        delay += 500;
      }
    },
    input(tone) {
      if (!this.allowInput) return;
      this.playTone(tone);
      this.userInput.push(tone);
      if (
        this.userInput[this.userInput.length - 1] !=
        this.series[this.userInput.length - 1]
      ) {
        this.userInput = [];
        this.allowInput = false;
        let self = this;
        this.showError = true;
        setTimeout(function () {
          self.showError = false;
          self.playSeries();
        }, 1000);
        return;
      }
      if (this.userInput.length == this.series.length) {
        let self = this;
        this.userInput = [];
        if (this.series.length == this.totalToWin) {
          setTimeout(this.winner, 500);
        } else {
          setTimeout(function () {
            self.addTone();
            self.playSeries();
          }, 1000);
        }
      }
    },
    togglePower() {
      this.power = !this.power;
      if (!this.power) {
        this.reset();
        this.stopTones();
      }
    },
    start() {
      if (this.power && this.count == 0) {
        this.started = true;
        this.addTone();
        this.playSeries();
      }
    },
    addTone() {
      this.count++;
      this.series.push(this.randomTone());
    },
    playSeries() {
      this.allowInput = false;
      this.playingSeries = true;
      let self = this;
      let delay = this.delay;
      this.series.forEach(function (tone, index, array) {
        if (index == array.length - 1)
          setTimeout(function () {
            if (self.started) {
              self.playTone(tone);
              self.allowInput = true;
              self.playingSeries = false;
            }
          }, delay);
        else
          setTimeout(function () {
            self.playTone(tone);
          }, delay);
        delay += 1000;
      });
      this.playingSeries = false;
    },
    clearHighlights() {
      this.hlGreen = false;
      this.hlRed = false;
      this.hlYellow = false;
      this.hlBlue = false;
    },
    playTone(tone) {
      if (!this.power) return;
      switch (tone) {
        case 1:
          this.$refs.sound1.pause();
          this.$refs.sound1.currentTime = 0;
          this.$refs.sound1.play();
          this.hlGreen = true;
          break;
        case 2:
          this.$refs.sound2.pause();
          this.$refs.sound2.currentTime = 0;
          this.$refs.sound2.play();
          this.hlRed = true;
          break;
        case 3:
          this.$refs.sound3.pause();
          this.$refs.sound3.currentTime = 0;
          this.$refs.sound3.play();
          this.hlYellow = true;
          break;
        case 4:
          this.$refs.sound4.pause();
          this.$refs.sound4.currentTime = 0;
          this.$refs.sound4.play();
          this.hlBlue = true;
          break;
      }
      if (!this.showWin) setTimeout(this.clearHighlights, 750);
    },
    stopTones() {
      this.$refs.sound1.pause();
      this.$refs.sound2.pause();
      this.$refs.sound3.pause();
      this.$refs.sound4.pause();
      this.$refs.sound1.currentTime = 0;
      this.$refs.sound2.currentTime = 0;
      this.$refs.sound3.currentTime = 0;
      this.$refs.sound4.currentTime = 0;
    },
    randomTone() {
      return Math.floor(Math.random() * 4) + 1;
    },
    toggleSpeed(flag) {
      switch (flag) {
        case "I":
          this.delay = 1500;
          return;
        case "II":
          this.delay = 1000;
          return;
        case "III":
          this.delay = 400;
          return;
      }
    },
  },
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

body {
  font-family: "Open Sans", sans-serif;
  user-select: none;
  background-color: #00f7ff;
}
h1 {
  font-family: "Russo One", sans-serif;
  font-size: 3rem;
  cursor: default;
  margin: 1rem 0;
}
.radio-group {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  width: 45px;
  margin-bottom: 18px;
}
#simon {
  margin: 2rem auto 0 auto;
  max-width: 680px;
  min-width: 680px;
  max-height: 680px;
  min-height: 680px;
  background-color: #2e2e2e;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  box-shadow: 0px 20px 18px rgba(0, 0, 0, 0.6);
  border-bottom: #000 10px solid;
  transform: rotate3d(1, 0, 0, 45deg);
}
#buttons {
  display: flex;
  flex-wrap: wrap;
  max-width: 620px;
  min-width: 620px;
  justify-content: space-between;
}
.button {
  cursor: pointer;
  min-width: 300px;
  min-height: 300px;
  max-width: 300px;
  max-height: 300px;
}
#green {
  background-color: darkgreen;
  border-top-left-radius: 300px;
  margin-bottom: 20px;
  box-shadow: inset 3px 3px 10px rgba(0, 0, 0, 0.3);
}
#blue {
  background-color: blue;
  border-bottom-right-radius: 300px;
  box-shadow: inset -3px -3px 10px rgba(0, 0, 0, 0.3);
}
#yellow {
  background-color: darkorange;
  border-bottom-left-radius: 300px;
  box-shadow: inset 3px -3px 10px rgba(0, 0, 0, 0.3);
}
#red {
  background-color: darkred;
  border-top-right-radius: 300px;
  margin-bottom: 20px;
  box-shadow: inset -3px 3px 10px rgba(0, 0, 0, 0.3);
}
#green.highlight {
  background-color: lightgreen;
}
#red.highlight {
  background-color: lightcoral;
}
#blue.highlight {
  background-color: skyblue;
}
#yellow.highlight {
  background-color: yellow;
}

#center {
  border: 20px solid #2e2e2e;
  box-sizing: border-box;
  box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.3);
  position: absolute;
  min-width: 300px;
  max-width: 300px;
  min-height: 300px;
  max-height: 300px;
  border-radius: 50%;
  background-color: #ccc;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  color: #2e2e2e;
}
#title {
  margin-top: 20px;
  text-align: center;
  background-color: #ccc;
  width: 200px;
  border-top-left-radius: 50%;
  border-top-right-radius: 50%;
}
#controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  min-width: 180px;
  margin-top: 0.5rem;
}
#counter {
  display: inline-block;
  width: 115px;
  height: 40px;
  color: #666;
  background-color: #000;
  border: 4px solid #2e2e2e;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  font-size: 1.6rem;
}
.lit {
  color: darkred;
}
#power {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 110px;
  font-size: 0.875rem;
  text-transform: uppercase;
  font-weight: bold;
}
#switch {
  cursor: pointer;
  display: inline-block;
  width: 50px;
  height: 25px;
  background-color: #2e2e2e;
  position: relative;
  border-radius: 5px;
}
#switch:after {
  content: "";
  position: absolute;
  top: 0;
  height: 19px;
  width: 19px;
  border: 3px solid #2e2e2e;
  background-color: darkred;
  left: 0;
  border-radius: 5px;
}
#switch.on:after {
  right: 0;
  left: auto;
}
.btn {
  cursor: pointer;
  position: relative;
  display: inline-block;
  width: 24px;
  height: 24px;
  background-color: darkgreen;
  border-radius: 50%;
  border: 4px solid #2e2e2e;
  margin-top: 1rem;
  box-shadow: 2px 2px 3px rgba(0, 0, 0, 0.4);
}
.btn::after {
  position: absolute;
  top: -20px;
  left: -25%;
  font-size: 12px;
  text-transform: uppercase;
  font-weight: bold;
}
.btn:hover {
  background-color: lightgreen;
}
#start.btn {
  background-color: darkred;
}
#start.btn:hover {
  background-color: lightcoral;
}
</style>
