
# AcoTriangulator: Acoustic Triangulation using TDoA Sensing

## Project Description
AcoTriangulator is an acoustic triangulation system designed to accurately locate the position of a sound source within a rectangular grid. The system uses Time Difference of Arrival (TDoA) and a distributed sensor network of microphones to achieve this goal.

## Subsystems
The project is divided into several subsystems, including:

1. **Data Acquisition and Pre-processing**: 
This subsystem handles sound signal capture and initial processing. It ensures that the microphones and Raspberry Pis are correctly set up and maintained.

2. **Data Analysis and Processing**: 
This subsystem further processes the acquired data. It calculates the TDoA of the sound signals and uses this data to compute the two-dimensional coordinates of the sound source.

3. **User Interface and Testing**: 
This subsystem displays the calculated position on a user-friendly interface. It also includes testing and validation functionalities to ensure system accuracy and reliability.

## Setup
1. Clone the repository to your local machine.
2. Ensure you have all the necessary hardware, including the Raspberry Pis, the microphones, and a suitable audio source.
3. Follow the setup instructions in the documentation to set up your hardware and software environment.

## Usage
1. Run the main program. This initiates data acquisition and processing.
2. The system will capture the audio signals, calculate the TDoA, and then calculate the sound source's position.
3. The calculated position will be displayed on the graphical user interface.

## Contributing
Contributions are welcome! Please read the contributing guidelines before making any changes.

## License
This project is licensed under the GPL 3.0 license. Please see the `LICENSE` file for more information.

## Contact
Please contact us if you have any questions, suggestions, or feedback.
- Email: echo3097s@gmail.com

"AcoTriangulator - Bringing precision to sound localisation!"
