// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HotelBooking {
    address public owner;
    uint256 public roomCount;
    uint256 public bookingCount;

    // Simulated "current day" so cancellation and check-in rules are easy to
    // test in Remix. A production version would use block.timestamp.
    uint256 public today;

    enum Status { Active, Cancelled, CheckedIn }

    struct Room {
        uint256 pricePerNight; // in wei
        bool exists;
    }

    struct Booking {
        address guest;
        uint256 roomId;
        uint256 checkIn;   // day number
        uint256 checkOut;  // day number (guest leaves this day)
        uint256 amountPaid;
        bytes32 guestHash; // keccak256 of guest details kept off-chain
        Status status;
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
    event BookingCancelled(uint256 indexed bookingId, address indexed guest, uint256 refund);
    event CheckedIn(uint256 indexed bookingId, address indexed guest, uint256 paidToHotel);
    event DayChanged(uint256 newDay);

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

    function setToday(uint256 newDay) external onlyOwner {
        require(newDay >= today, "Day cannot go backwards");
        today = newDay;
        emit DayChanged(newDay);
    }

    function bookRoom(
        uint256 roomId,
        uint256 checkInDay,
        uint256 checkOutDay,
        bytes32 guestHash
    ) external payable {
        require(rooms[roomId].exists, "Room does not exist");
        require(checkOutDay > checkInDay, "Check-out must be after check-in");

        for (uint256 d = checkInDay; d < checkOutDay; d++) {
            require(!nightBooked[roomId][d], "Room not available for these dates");
        }

        uint256 total = rooms[roomId].pricePerNight * (checkOutDay - checkInDay);
        require(msg.value == total, "Incorrect payment amount");

        for (uint256 d = checkInDay; d < checkOutDay; d++) {
            nightBooked[roomId][d] = true;
        }

        bookingCount++;
        bookings[bookingCount] = Booking(
            msg.sender, roomId, checkInDay, checkOutDay, msg.value, guestHash, Status.Active
        );

        emit RoomBooked(bookingCount, roomId, msg.sender, checkInDay, checkOutDay, msg.value);
    }

    function cancelBooking(uint256 bookingId) external {
        Booking storage b = bookings[bookingId];
        require(b.guest != address(0), "Booking does not exist");
        require(msg.sender == b.guest, "Only the guest can cancel");
        require(b.status == Status.Active, "Booking not active");
        require(today < b.checkIn, "Too late to cancel");

        // Update state BEFORE sending ETH (protects against re-entrancy)
        b.status = Status.Cancelled;
        for (uint256 d = b.checkIn; d < b.checkOut; d++) {
            nightBooked[b.roomId][d] = false;
        }

        uint256 refund = b.amountPaid;
        (bool ok, ) = payable(b.guest).call{value: refund}("");
        require(ok, "Refund failed");

        emit BookingCancelled(bookingId, b.guest, refund);
    }

    function checkIn(uint256 bookingId) external {
        Booking storage b = bookings[bookingId];
        require(b.guest != address(0), "Booking does not exist");
        require(msg.sender == b.guest, "Only the guest can check in");
        require(b.status == Status.Active, "Booking not active");
        require(today >= b.checkIn, "Too early to check in");

        b.status = Status.CheckedIn;

        uint256 payment = b.amountPaid;
        (bool ok, ) = payable(owner).call{value: payment}("");
        require(ok, "Payment to hotel failed");

        emit CheckedIn(bookingId, b.guest, payment);
    }
}