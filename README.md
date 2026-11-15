# Blockchain Hotel Booking System

**Student name:** Angel Leonardo Tamayo Angulo
**Student number:** 2024640
**Module:** Distributed Digital Transactions
**Assignment:** CA1 - Blockchain Application Design and Implementation

## Overview

This project proposes a blockchain-based solution for **hotel booking**. A Solidity smart contract acts as the trusted middle layer between guest and hotel. It holds payment in escrow, prevents double bookings, and handles refunds automatically, without a third-party booking platform.

## Technologies

- Solidity (smart contract)
- Remix IDE (development and testing, Remix VM)
- Python and Shell script (supporting scripts)
- Ganache (local blockchain, if used)
- GitHub (version control)

## Repository Structure

contracts/    Solidity smart contract(s)
docs/         Design document, cryptography notes, testing procedure
scripts/      Shell script and supporting scripts
screenshots/  Remix test screenshots
poster/       PowerPoint poster and video script

## Features (planned)

- Hotel owner adds rooms and sets the price per night
- Guest books a room and pays in ETH, held by the contract
- Availability checks prevent double booking
- Automatic refund on cancellation before the deadline
- Funds released to the hotel at check-in
- Events logged for every action

## Project Progress

- [x] Repository setup
- [x] Design document
- [x] Cryptography section and diagram
- [ ] Smart contract
- [ ] Testing and screenshots
- [ ] Poster, video and scripts