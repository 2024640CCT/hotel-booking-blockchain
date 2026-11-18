// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HotelBooking {
    address public owner;
    uint256 public roomCount;
    uint256 public bookingCount;

    struct Room {
        uint256 pricePerNight; // in wei
        bool exists;
    }

    struct Booking {
        address guest;
        uint256 roomId;
        uint256 checkIn;   // day number, e.g. 1, 2, 3
        uint256 checkOut;  // day number (guest leaves this day)
        uint256 amountPaid;
        bytes32 guestHash; // keccak256 of guest details kept off-chain
    }

    mapping(uint256 => Room) public rooms;
    mapping(uint256 => Booking) public bookings;
    mapping(uint256 => mapping(uint256 => bool)) public nightBooked;

    event RoomAdded(uint256 indexed roomId, uint256 pricePerNight);
    event RoomBooked(
        uint256 indexed bookingId,
        uint256 indexed roomId,
        address indexed guest,
        uint256 checkIn,
        uint256 checkOut,
        uint256 amountPaid
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the hotel owner can do this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addRoom(uint256 pricePerNight) external onlyOwner {
        require(pricePerNight > 0, "Price must be greater than 0");
        roomCount++;
        rooms[roomCount] = Room(pricePerNight, true);
        emit RoomAdded(roomCount, pricePerNight);
    }

    function bookRoom(
        uint256 roomId,
        uint256 checkIn,
        uint256 checkOut,
        bytes32 guestHash
    ) external payable {
        require(rooms[roomId].exists, "Room does not exist");
        require(checkOut > checkIn, "Check-out must be after check-in");

        for (uint256 d = checkIn; d < checkOut; d++) {
            require(!nightBooked[roomId][d], "Room not available for these dates");
        }

        uint256 total = rooms[roomId].pricePerNight * (checkOut - checkIn);
        require(msg.value == total, "Incorrect payment amount");

        for (uint256 d = checkIn; d < checkOut; d++) {
            nightBooked[roomId][d] = true;
        }

        bookingCount++;
        bookings[bookingCount] = Booking(
            msg.sender, roomId, checkIn, checkOut, msg.value, guestHash
        );

        emit RoomBooked(bookingCount, roomId, msg.sender, checkIn, checkOut, msg.value);
    }
}