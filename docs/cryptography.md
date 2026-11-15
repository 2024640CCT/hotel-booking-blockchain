# Cryptography and Architecture

##Cryptographic Methods

The solution uses two methods that Ethereum is built on:

1. Keccak-256 hashing (for data integrity and privacy)
2. ECDSA digital signatures on the secp256k1 curve (for authentication)

###Keccak-256 Hashing

A hash function turns any input into a fixed 256-bit output. It is one-way (the input cannot be recovered from the hash)
and changing even one character of the input produces a completely different hash.

How it is used in this project:
-Guest privacy: personal details (name, email, passport number) are never stored on the blockchain, because blockchain data is public. Instead the details are kept off-chain and only their hash is stored in the booking as `guestHash`. Adding a random value (a "salt") before hashing stops attackers guessing the details by hashing common names.
-Tamper detection: the hotel can later hash the details a guest presents and compare them with the on-chain hash. A match proves the details are unchanged.
-Blockchain integrity: each block contains the hash of the previous block, so altering a past booking would change every later hash and be rejected by the network.

###ECDSA Digital Signatures (secp256k1)

Every user has a private key and a matching public key. The user's wallet address is derived from the public key (the last 20 bytes of its Keccak-256 hash).

How it is used in this project:
-Authentication: every transaction (`addRoom`, `bookRoom`, `cancelBooking`, `checkIn`) is signed with the sender's private key. The network verifies the signature, so `msg.sender` in the contract cannot be faked.
-Authorisation: the contract uses `msg.sender` to ensure only the hotel owner can add rooms and only the original guest can cancel their own booking.
-Non-repudiation: a guest cannot deny making a booking, because only their private key could have produced the signature.
-Integrity: if a transaction is altered in transit, the signature no longer verifies.

##Why are these methods suitable?

Protect guest personal data: Keccak-256 works as a one-way, so the data cannot be recovered from the chain.
Prove who made a booking: With the ECDSA method only the private key holder can sign.
Detect tampering or falsification: Keccak-256 and signatures so any change breaks the hash or signature.
Efficiency: ECDSA(secp256k1) 256-bit keys give strong security with small, fast signatures.

**RSA would need much larger keys (about 3072 bits) for equivalent security, which would make transactions larger and costlier.
Keccak-256 is natively supported in Solidity as `keccak256()`, so it is cheap in gas and needs no external library.**

##Security Limitations

- Hashing protects privacy only if the off-chain data is stored securely.
- If a user loses or leaks their private key, their account is compromised, so wallet security is critical.
- Current elliptic-curve cryptography is a long-term target for quantum computers, and post-quantum signatures are an area of active research.
