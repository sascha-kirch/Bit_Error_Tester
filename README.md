# Bit_Error_Tester

This project implements a bit error rate tester. A PRBS (pseudo random bit sequence) is generated that can feed the DUT. The receiver compares the internally delayed transmitted signals with received signal and counts up an error counter if their logic levels differ. 

The design is written in HDL and it has been tested using a cyclone II FPGA board from ALTERA.

## Design Architecture
<img src="https://github.com/SaKi1309/Bit_Error_Tester/blob/main/imgs/blockschaltbild_test_backplane.png" width="800" />

## Block Diagram of Inputs and Outputs
<img src="https://github.com/SaKi1309/Bit_Error_Tester/blob/main/imgs/block.PNG" width="800" />

# Repo Stats
![](https://komarev.com/ghpvc/?username=saschakirchbert&color=yellow) since 16.04.2022
