Here’s the README translated into English:

---

# Fuleco vs Germany - A RISC-V Pacman Remake

![Fuleco Pacman Remake](path/to/image.png)

## Description
This is a remake of the classic **Pacman** game, developed in Assembly for the **RISC-V** architecture. Instead of Pacman, you play as Fuleco, the mascot of the 2014 World Cup, and the ghosts are players from the German national team that defeated Brazil in the infamous semi-final. The goal is to help Fuleco escape the players and restore his honor!

## Features
- **Main character:** Fuleco (2014 World Cup mascot).
- **Enemies:** Players from the German national football team.
- **Classic Pacman movement** with keyboard controls.
- **Score system** inspired by the original game.
- **Developed in Assembly for RISC-V architecture**.

## Requirements
To run the game, you will need:
- A **RISC-V simulator or emulator** (such as Spike or QEMU)
- **RISC-V GCC compiler** or another compatible assembler

## How to run the project

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/fuleco-vs-germany.git
   ```

2. Compile the code:
   ```bash
   riscv64-unknown-elf-gcc -o fuleco_vs_germany main.s
   ```

3. Run the game on a RISC-V emulator (like Spike or QEMU):
   ```bash
   spike pk fuleco_vs_germany
   ```

## Controls
- **Arrow keys**: move Fuleco
- **P**: pause the game
- **Q**: quit the game

## Code Structure
- `main.s`: Main file containing the game logic
- `graphics.s`: Functions for rendering the map and characters
- `input.s`: Player input handling
- `sound.s`: Simple sound implementation (optional)

## Contributions
Contributions are welcome! Feel free to open issues and submit pull requests.

## License
This project is licensed under the [MIT License](LICENSE).

---

Feel free to add screenshots or gameplay videos to make it more engaging!
