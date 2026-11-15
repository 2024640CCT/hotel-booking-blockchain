## 1. Problem Statement

Hotel bookings today mostly go through centralised platforms or the hotels own system. This creates several problems:

- High commission fees: platforms usually charge hotels around 15-25% per booking.
- Control of data: one company holds all guest and booking data, which creates privacy and single point of failure risks because usually these systems dont have
  backup.
- Disputes: disagreements over cancellations, refunds and no-shows depend on trusting the platform or the hotel.
- Double bookings and overbooking: caused by out-of-sync systems across multiple channels and plataforms.
- Slow payments: hotels can wait weeks to be paid by intermediaries or third parties.

## 2. Proposed Solution

A smart contract on a blockchain acts as the trusted middle layer between the guest and the hotel. 
Instead of trusting a platform, both parties trust code that is public and cannot be altered.


The contract:
1. Stores the rooms and their prices per night.
2. Accepts payment from the guest and holds it in escrow.
3. Blocks the room for the booked nights so it cannot be booked twice.
4. Releases the funds to the hotel at check-in.
5. Refunds the guest automatically if they cancel before the deadline.
6. Records every action as an event, giving a transparent audit trail.

## 3. Actors

Hotel owner: Deploys the contract, adds rooms, sets prices.

Guests: Books a room, pays, may cancel, checks in. 

Smart contract: Middle layer enforces rules, holds funds, records bookings.

## 4. Booking Flow

1. The owner deploys the contract and adds rooms with a price per night.
2. A guest chooses a room and dates and calls `bookRoom`, sending the exact payment.
3. The contract checks availability, locks the nights and stores the booking.
4. If the guest cancels before the deadline, `cancelBooking` refunds them and frees the room.
5. On arrival, `checkIn` releases the held funds to the hotel owner.

## 5. Pros

- No intermediary fees so lower costs for hotels and guests.
- Transparency: every booking and payment is publicly verifiable.
- Immutability: records cannot be altered after the fact.
- No double bookings: availability is enforced by the contract.
- Automation: refunds and payouts happen without manual handling.
- Faster settlement than traditional payment chains.
- Reduced fraud because funds are held in escrow.

## 6. Cons

- Gas fees: every transaction costs gas which can be high on busy networks.
- Scalability: low transaction throughput on a base blockchain.
- Privacy: blockchain data is public, so personal data must stay off-chain.
- Regulation: unclear rules around crypto payments, tax and consumer protection.
- Price volatility: a room priced in ETH can change value quickly.
- Usability: guests need a crypto wallet and some technical knowledge.
- Immutability cuts both ways: a bug in a deployed contract is hard to fix, so testing and audits are needed.

## 7. Recent Advancements in Blockchain Technology

- Layer-2 rollups (Arbitrum, Optimism, Base) cut gas fees and speed up transactions, which makes small payments like hotel bookings practical.
- Proof of Stake: Ethereum's 2022 Merge reduced its energy use by over 99%, addressing sustainability concerns.
- Stablecoins ( for example USDC) remove price volatility from payments.
- NFTs as booking vouchers allow bookings to be transferred or resold securely.
- Zero-knowledge proofs let a guest prove something (like age or identity) without revealing any personal data.
- Account abstraction makes wallets easier to use, for example by allowing gas to be sponsored by the hotel.